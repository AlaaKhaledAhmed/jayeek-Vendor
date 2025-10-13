import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final String input;
  final double amount;
  final bool isLoading;

  const HomeState({this.amount = 0, this.input = '', this.isLoading = false});

  HomeState copyWith({String? input, double? amount, isLoading, int? page}) {
    return HomeState(
      input: input ?? this.input,
      amount: amount ?? this.amount,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [amount, input, isLoading];
}
