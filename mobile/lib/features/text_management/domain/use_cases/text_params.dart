import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';

class TextParams extends Equatable {
  final MyText text;

  TextParams({@required this.text});

  @override
  List<Object> get props => [TextParams];
}
