import 'package:flutter/foundation.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';

class Statistic {
  final Student student;
  final String cardContent;

  Statistic({@required this.student})
      : cardContent =
            '${student.firstName} ${student.lastName} had his/her fluency assessed in DATE. He/She read the text in X minutes and Y seconds with Z% of correctness.';
}
