import 'package:equatable/equatable.dart';

class SingUpState extends Equatable {
  final bool isLoading;

  const SingUpState({this.isLoading = false});
  SingUpState copyWith({bool? isLoading}) {
    return SingUpState(isLoading: isLoading ?? this.isLoading);
  }

  @override
  List<Object?> get props => [isLoading];
}
