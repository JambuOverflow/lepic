/*1- dar get passando um datetime, ai vcs mandariam todas as turmas que foram modificadas depois desse datetime.
2- No cliente, vamos iterar por cada uma dessas turmas
2.1  e ver se devemos no cliente adicionar/atualizar dependendo se essas turmas estão ou não banco do cliente
3- No cliente, vamos iterar por cada uma das turmas que foram modificadas após o último sync
3.1- da get no server usando a pk delas, se retornar algo a gt manda put, se n retornar nada a gt manda post
*/
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import "package:http/http.dart" as http;
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/features/class_management/data/data_sources/classroom_local_data_source.dart';
import '../../../../core/network/response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SyncClassroom {
  final http.Client client;
  final FlutterSecureStorage secureStorage;
  final ClassroomLocalDataSourceImpl classroomLocalDataSourceImpl;
  final String api_url;
  DateTime lastSyncTime = DateTime.now().toUtc();

  SyncClassroom(
      {@required this.client,
      @required this.secureStorage,
      @required this.classroomLocalDataSourceImpl,
      @required this.api_url});

  String getUrl() {
    return this.api_url + "classes/";
  }

  Future<Response> sync() async {
    Response pullResponse = await this.pull();
    if (pullResponse is UnsuccessfulResponse) {
      return pullResponse;
    }

    Response pushResponse = await this.push();
    if (pushResponse is UnsuccessfulResponse) {
      return pushResponse;
    }

    this.lastSyncTime = DateTime.now().toUtc();
    return SuccessfulResponse();
  }

  // Gets from server the classrooms that were updated synce last time
  Future<http.Response> getServerUpdated(
      String lastSyncTime, String token) async {
    String url = getUrl();
    if (lastSyncTime != "") {
      url = url + "?last_sync=${lastSyncTime}";
    }
    final headers = getHeaders(token);
    final response = await this.client.get(url, headers: headers);

    return response;
  }

  Map<String, String> getHeaders(String token) {
    return {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "token ${token}",
    };
  }

  Future<String> getToken() async {
    final token = await secureStorage.read(key: 'token');
    return token;
  }

  Future<Response> pull() async {
    final token = await getToken();
    final lastSyncTimeString = this.lastSyncTime.toString();
    http.Response response =
        await this.getServerUpdated(lastSyncTimeString, token);

    if (response.statusCode == 401) {
      return UnsuccessfulResponse(message: response.body);
    }

    Iterable objects = json.decode(response.body);

    objects.forEach((element) async {
      ClassroomModel model = ClassroomModel.fromJson(element);
      this.classroomLocalDataSourceImpl.cacheClassroom(model);
    });
    return SuccessfulResponse();
  }

  bool isInCollection(ClassroomModel model, List<ClassroomModel> collection) {
    bool result = false;
    for (ClassroomModel element in collection) {
      if (element.localId == model.localId) {
        result = true;
        break;
      }
    }
    return result;
  }

  Future<Response> push() async {
    List<ClassroomModel> classroomsToPush = await this
        .classroomLocalDataSourceImpl
        .getClassroomsSinceLastSync(this.lastSyncTime);
    final token = await getToken();

    try {
      List<ClassroomModel> classroomsInServer =
          await getClassroomsInServer(token);
      bool inServer;
      classroomsToPush.forEach((element) async {
        inServer = this.isInCollection(element, classroomsInServer);
        if (inServer) {
          await putClassroom(element, token);
        } else {
          await postClassroom(element, token);
        }
      });
    } on ServerException {
      return UnsuccessfulResponse(message: "Error when pushing");
    }
    return SuccessfulResponse();
  }

  Future<List<ClassroomModel>> getClassroomsInServer(String token) async {
    http.Response response = await this.getServerUpdated("", token);
    if (response.statusCode == 200) {
      Iterable objects = json.decode(response.body);
      List<ClassroomModel> classroomsInServer = [];
      objects.forEach((element) {
        classroomsInServer.add(ClassroomModel.fromJson(element));
      });
      return classroomsInServer;
    } else {
      throw ServerException();
    }
  }

  Future<void> putClassroom(ClassroomModel element, String token) async {
    final headers = getHeaders(token);
    final localUrl = this.getUrl() + "${element.localId}/";
    final body = json.encode(element.toJson());
    final http.Response response = await this.client.put(
          localUrl,
          headers: headers,
          body: body,
        );
    print(response.statusCode);
    if (response.statusCode != 200) {
      throw ServerException(message: response.body);
    }
  }

  Future<void> postClassroom(ClassroomModel element, String token) async {
    final headers = getHeaders(token);
    final localUrl = this.getUrl();
    final body = json.encode([element.toJson()]);

    final http.Response response = await this.client.post(
          localUrl,
          headers: headers,
          body: body,
        );
    if (response.statusCode != 201) {
      throw ServerException(message: response.body);
    }
  }
}
