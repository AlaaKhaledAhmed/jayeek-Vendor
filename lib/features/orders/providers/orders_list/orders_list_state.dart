import 'package:equatable/equatable.dart';
import '../../data/models/order_model.dart';

class OrdersListState extends Equatable {
  final List<OrderModel> orders;
  final bool isLoading;
  final OrderStatus? selectedStatus;
  final bool hasError;
  final String? errorMessage;
  final bool isRefreshing;
  final int currentPage;
  final bool hasMore;

  const OrdersListState({
    this.orders = const [],
    this.isLoading = false,
    this.selectedStatus,
    this.hasError = false,
    this.errorMessage,
    this.isRefreshing = false,
    this.currentPage = 1,
    this.hasMore = true,
  });

  OrdersListState copyWith({
    List<OrderModel>? orders,
    bool? isLoading,
    OrderStatus? selectedStatus,
    bool? hasError,
    String? errorMessage,
    bool? isRefreshing,
    int? currentPage,
    bool? hasMore,
    bool clearStatus = false,
  }) {
    return OrdersListState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      selectedStatus:
          clearStatus ? null : selectedStatus ?? this.selectedStatus,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [
        orders,
        isLoading,
        selectedStatus,
        hasError,
        errorMessage,
        isRefreshing,
        currentPage,
        hasMore,
      ];
}
