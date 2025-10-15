import 'package:equatable/equatable.dart';
import '../../data/models/order_model.dart';

class OrderDetailsState extends Equatable {
  final OrderModel? order;
  final bool isLoading;
  final bool isUpdating;
  final bool hasError;
  final String? errorMessage;

  const OrderDetailsState({
    this.order,
    this.isLoading = false,
    this.isUpdating = false,
    this.hasError = false,
    this.errorMessage,
  });

  OrderDetailsState copyWith({
    OrderModel? order,
    bool? isLoading,
    bool? isUpdating,
    bool? hasError,
    String? errorMessage,
  }) {
    return OrderDetailsState(
      order: order ?? this.order,
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [order, isLoading, isUpdating, hasError, errorMessage];
}
