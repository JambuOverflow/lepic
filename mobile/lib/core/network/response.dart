import 'package:equatable/equatable.dart';

class Response extends Equatable {
  final String message;

  Response({this.message});

  @override
  List<Object> get props => [Response];
}
