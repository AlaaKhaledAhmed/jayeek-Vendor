import '../../domain/entity/file_upload_data.dart';
import '../../model/data_handel.dart';

abstract class INetworkServices {
  ///this class have abstract method using in this layer

  Future<PostDataHandle<T>> get<T>({
    required String url,
    Map<String, dynamic>? queryParams,
    bool requiresToken = true,
    required T Function(Map<String, dynamic>) fromJson,
  });

  Future<PostDataHandle<T>> post<T>({
    required String url,
    Map<String, dynamic>? body,
    bool requiresToken = true,
    T Function(Map<String, dynamic>)? fromJson,
  });

  Future<PostDataHandle<T>> put<T>({
    required String url,
    Map<String, dynamic>? body,
    bool requiresToken = true,
    T Function(Map<String, dynamic>)? fromJson,
  });
  Future<PostDataHandle<T>> delete<T>({
    required String url,
    Map<String, dynamic>? body,
    bool requiresToken = true,
    T Function(Map<String, dynamic>)? fromJson,
    Map<String, dynamic>? queryParams,
  });

  Future<PostDataHandle<T>> uploadFile<T>({
    required String url,
    Map<String, dynamic>? body,
    bool requiresToken = true,
    List<FileUploadData> files,
    required T Function(Map<String, dynamic>) fromJson,
  });
}
