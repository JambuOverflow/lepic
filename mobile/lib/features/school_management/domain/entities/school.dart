import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

enum Modality { municipal, estadual, federal, privada }

class School extends Equatable {
  final int id;
  final int userId;
  final int zipCode;
  final Modality modality;
  final String state;
  final String city;
  final String neighborhood;
  final String name;

  School(
      {@required this.userId,
      @required this.zipCode,
      @required this.modality,
      @required this.state,
      @required this.city,
      @required this.neighborhood,
      @required this.name,
      this.id});

  @override
  List<Object> get props =>
      [userId, zipCode, modality, state, city, neighborhood, name, id];
}
