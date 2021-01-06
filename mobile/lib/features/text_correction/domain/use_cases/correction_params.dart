import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/features/text_correction/domain/entities/correction.dart';

class CorrectionParams extends Equatable {
  final Correction correction;

  CorrectionParams({@required this.correction});

  @override
  List<Object> get props => [correction];
}
