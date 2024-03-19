import 'package:equatable/equatable.dart';

class LoginState extends Equatable{
  const LoginState();

  @override
  List<Object> get props => [];

}

class LoginStateInitial extends LoginState{
  const LoginStateInitial();

  @override
  List<Object> get props => [];
}

class LoginStateLoading extends LoginState{
  const LoginStateLoading();

  @override
  List<Object> get props => [];
}

class LoginStateSuccess extends LoginState{
  const LoginStateSuccess();

  @override
  List<Object> get props => [];
}

class SignUpStateSuccess extends LoginState{
  const SignUpStateSuccess();

  @override
  List<Object> get props => [];
}

class SentVerifyEmailState extends LoginState{
  const SentVerifyEmailState();

  @override
  List<Object> get props => [];
}

class VerifyEmailStateSuccess extends LoginState{
  const VerifyEmailStateSuccess();

  @override
  List<Object> get props => [];
}

class LoginStateError extends LoginState{
  final String error;
  const LoginStateError(this.error);

  @override
  List<Object> get props => [error];
}
