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
import 'package:mobile/features/class_management/data/data_sources/classroom_local_data_source.dart';
import '../../../../core/network/response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const API_URL = 'lepic-django.herokuapp.com';

class SyncClassroom {
  final http.Client client;
  final FlutterSecureStorage secureStorage;
  final ClassroomLocalDataSourceImpl classroomLocalDataSourceImpl;
  DateTime lastSyncTime = DateTime.now();

  SyncClassroom({
    @required this.client,
    @required this.secureStorage,
    @required this.classroomLocalDataSourceImpl,
  });

  // Gets from server the classrooms that were updated synce last time
  Future<http.Response> getServerUpdated(String lastSyncTime) async {
    final token = await secureStorage.read(key: 'token');

    final queryParameters = {'last_sync_time': lastSyncTime};
    final uri = Uri.http(API_URL, 'api/classes/', queryParameters);
    final headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "token ${token}",
    };

    return await this.client.get(uri, headers: headers);
  }

  Future<Response> pull() async {
    final lastSyncTimeString = this.lastSyncTime.toString();
    http.Response response = await this.getServerUpdated(lastSyncTimeString);

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
}
