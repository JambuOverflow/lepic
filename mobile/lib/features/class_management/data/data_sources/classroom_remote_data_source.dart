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
import 'package:mobile/features/user_management/data/data_sources/user_local_data_source.dart';
import '../../../../core/network/response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:clock/clock.dart';

abstract class ClassroomRemoteDataSource {
  /// Returns the url of the object
  String getUrl();

  /// Does a pull and push
  Future<Response> synchronize();

  /// Gets a response from the server with the objects
  /// that have 'last_update' > lastSyncTime
  Future<http.Response> getServerUpdated(String lastSyncTime, String token);

  /// Returns the headers of requests
  Map<String, String> getHeaders(String token);

  /// Gets the user token
  Future<String> getToken();

  /// update outdated client objects
  Future<Response> pull();

  /// update outdated server objects
  Future<Response> push();

  /// converts server format to classroomModel
  Future<ClassroomModel> serverJsonToClassroomModel(element);

  /// Checks if model localId is in collection
  isInCollection(ClassroomModel model, List<ClassroomModel> collection);

  /// Gets all classrooms form server
  Future<List<ClassroomModel>> getClassroomsInServer(String token);

  /// Sends a put request to the server
  Future<void> putClassroom(ClassroomModel element, String token);

  /// Sends a post request to the server
  Future<void> postClassroom(ClassroomModel element, String token);
}

class ClassroomRemoteDataSourceImpl extends ClassroomRemoteDataSource {
  final http.Client client;
  final FlutterSecureStorage secureStorage;
  final ClassroomLocalDataSourceImpl classroomLocalDataSourceImpl;
  final String api_url;
  final Clock clock;
  final UserLocalDataSource userLocalDataSource;
  DateTime lastSyncTime = DateTime(2010).toUtc();

  ClassroomRemoteDataSourceImpl(
      {@required this.client,
      @required this.secureStorage,
      @required this.classroomLocalDataSourceImpl,
      @required this.api_url,
      @required this.clock,
      @required this.userLocalDataSource});

  String getUrl() {
    return this.api_url + "classes/";
  }

  Future<Response> synchronize() async {
    Response pullResponse = await this.pull();
    if (pullResponse is UnsuccessfulResponse) {
      return pullResponse;
    }

    Response pushResponse = await this.push();
    if (pushResponse is UnsuccessfulResponse) {
      return pushResponse;
    }

    this.lastSyncTime = clock.now().toUtc();
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

    final body = response.body;
    Iterable objects = json.decode(body);

    for (var element in objects) {
      ClassroomModel model = await serverJsonToClassroomModel(element);
      await classroomLocalDataSourceImpl.cacheClassroom(model);
    }
    return SuccessfulResponse();
  }

  Future<ClassroomModel> serverJsonToClassroomModel(element) async {
    final int localId = element['local_id'];
    final int grade = element['grade'];
    final String title = element['title'];
    final DateTime lastUpdated = DateTime.parse(element['last_update']);
    final int school = element['school'];
    final bool deleted = element['deleted'];
    final DateTime clientLastUpdated = clock.now().toUtc();
    final userId = await userLocalDataSource.getUserId();

    ClassroomModel model = ClassroomModel(
        localId: localId,
        grade: grade,
        title: title,
        lastUpdated: lastUpdated,
        school: school,
        tutorId: userId,
        deleted: deleted,
        clientLastUpdated: clientLastUpdated);
    return model;
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
      for (var element in classroomsToPush) {
        inServer = this.isInCollection(element, classroomsInServer);
        if (inServer) {
          await putClassroom(element, token);
        } else {
          await postClassroom(element, token);
        }
      }
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
      for (var element in objects) {
        ClassroomModel model = await serverJsonToClassroomModel(element);
        classroomsInServer.add(model);
      }
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
