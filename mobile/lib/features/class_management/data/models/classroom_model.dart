import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/user_management/data/models/user_model.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';

class ClassroomModel extends Classroom {
  ClassroomModel({
    @required UserModel tutor,
    @required int grade,
    @required String name,
    @required int id,
  }) : super(grade: grade, tutor: tutor, name: name, id: id);

  factory ClassroomModel.fromJson(Map<String, dynamic> json) {
    final tutor = UserModel.fromJson(json['tutor']);

    return ClassroomModel(
      tutor: tutor,
      grade: (json['grade'] as num).toInt(),
      name: json['name'],
      id: (json['id'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tutor': (tutor as UserModel).toJson(),
      'grade': grade,
      'id': id,
      'name': name,
    };
  }
}

/*
return Classroommodel(
  tutor: ){

  },
  grade: 2,
  name: 'lixo'
*/
