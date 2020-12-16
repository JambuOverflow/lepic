part of 'user_form_bloc.dart';

abstract class UserFormState extends Equatable {
  const UserFormState();
  
  @override
  List<Object> get props => [];
}

class UserFormInitial extends UserFormState {}
