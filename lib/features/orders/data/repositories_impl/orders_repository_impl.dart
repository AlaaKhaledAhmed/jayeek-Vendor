import '../../../../../core/constants/app_end_points.dart';
import '../../../../../core/model/data_handel.dart';
import '../../../../../core/services/network/inetwork_services.dart';
import '../../domain/repositories/orders_repository.dart';
import '../models/order_model.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final INetworkServices networkService;

  OrdersRepositoryImpl({required this.networkService});

  @override
  Future<PostDataHandle<List<OrderModel>>> getOrders({
    OrderStatus? status,
    int page = 1,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      if (status != null) 'status': status.value,
    };

    final result = await networkService.get<List<OrderModel>>(
      url: ApiEndPoints.ordersUrl,
      requiresToken: true,
      queryParams: queryParams,
      fromJson: (json) {
        final ordersJson = json['orders'] as List? ?? [];
        return ordersJson
            .map((order) => OrderModel.fromJson(order as Map<String, dynamic>))
            .toList();
      },
    );

    return result;
  }

  @override
  Future<PostDataHandle<OrderModel>> getOrderDetails({
    required String orderId,
  }) async {
    return await networkService.get<OrderModel>(
      url: '${ApiEndPoints.ordersUrl}/$orderId',
      requiresToken: true,
      fromJson: (json) => OrderModel.fromJson(json['order']),
    );
  }

  @override
  Future<PostDataHandle<bool>> updateOrderStatus({
    required String orderId,
    required OrderStatus newStatus,
  }) async {
    return await networkService.post<bool>(
      url: '${ApiEndPoints.ordersUrl}/$orderId/status',
      requiresToken: true,
      body: {
        'status': newStatus.value,
      },
    );
  }

  @override
  Future<PostDataHandle<bool>> acceptOrder({
    required String orderId,
    int? estimatedTime,
  }) async {
    return await networkService.post<bool>(
      url: '${ApiEndPoints.ordersUrl}/$orderId/accept',
      requiresToken: true,
      body: {
        if (estimatedTime != null) 'estimated_time': estimatedTime,
      },
    );
  }

  @override
  Future<PostDataHandle<bool>> rejectOrder({
    required String orderId,
    String? reason,
  }) async {
    return await networkService.post<bool>(
      url: '${ApiEndPoints.ordersUrl}/$orderId/reject',
      requiresToken: true,
      body: {
        if (reason != null) 'reason': reason,
      },
    );
  }
}
