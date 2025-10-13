import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final bool isLoading;

  const LoginState({this.isLoading = false});
  LoginState copyWith({bool? isLoading}) {
    return LoginState(isLoading: isLoading ?? this.isLoading);
  }

  @override
  List<Object?> get props => [isLoading];
}
