part of 'class_bloc.dart';

abstract class ClassState extends Equatable {
  const ClassState();

  @override
  List<Object> get props => [ClassState];
}

class DeletingClass extends ClassState {}

class ClassDeleted extends ClassState {}

class CreatingClass extends ClassState {}

class ClassCreated extends ClassState {
  final Response response;

  ClassCreated({@required this.response});
}

class UpdatingClass extends ClassState {}

class ClassUpdated extends ClassState {}

class GetClass /*GettingClass*/ extends ClassState {}

class GotClass extends ClassState {
  final Response response;
  GotClass({@required this.response});
}

class Error extends ClassState {
  final String message;

  Error({@required this.message});
}
