import 'package:dio/dio.dart';
import '../../constants/app_constants.dart';
import '../../domain/entity/file_upload_data.dart';
import '../../error/app_error_state.dart';
import '../../error/exceptions_handler.dart';
import '../../model/data_handel.dart';
import '../../util/print_info.dart';
import '../language_service.dart';
import '../shared_preferences_service.dart';
import 'inetwork_services.dart';

class DioNetworkService implements INetworkServices {
  final Dio _dio;
  DioNetworkService(this._dio);

  @override
  Future<PostDataHandle<T>> get<T>({
    required String url,
    Map<String, dynamic>? queryParams,
    bool requiresToken = true,
    required T Function(Map<String, dynamic>) fromJson,
  }) {
    return _sendRequest<T>(
      requiresToken: requiresToken,
      url: url,
      method: 'GET',
      queryParams: queryParams,
      fromJson: fromJson,
    );
  }

  @override
  Future<PostDataHandle<T>> post<T>({
    required String url,
    Map<String, dynamic>? body,
    bool requiresToken = true,
    T Function(Map<String, dynamic>)? fromJson,
  }) {
    return _sendRequest<T>(
      requiresToken: requiresToken,
      url: url,
      method: 'POST',
      body: body,
      fromJson: fromJson,
    );
  }

  @override
  Future<PostDataHandle<T>> uploadFile<T>({
    required String url,
    Map<String, dynamic>? body,
    bool requiresToken = true,
    List<FileUploadData>? files,
    required T Function(Map<String, dynamic>) fromJson,
  }) {
    return _sendRequest<T>(
      requiresToken: requiresToken,
      url: url,
      method: 'POST',
      body: body,
      fromJson: fromJson,
      files: files,
      isMultiData: true,
    );
  }

  Future<PostDataHandle<T>> _sendRequest<T>({
    required bool requiresToken,
    required String url,
    required String method,
    Map<String, dynamic>? body,
    List<FileUploadData>? files,
    T Function(Map<String, dynamic>)? fromJson,
    Map<String, dynamic>? queryParams,
    bool isMultiData = false,
  }) async {
    try {
      /// === Prepare Headers ===
      final token = await SharedPreferencesService.getToken();

      final headers = <String, String>{
        'Accept': 'application/json',
        'Content-Type':
            isMultiData ? 'multipart/form-data' : 'application/json',
        if (requiresToken && token != null) 'Authorization': 'Bearer $token',
      };

      /// === Build FormData for multipart requests ===
      FormData? formData;
      if (isMultiData && files != null && files.isNotEmpty) {
        final multipartMap = <String, dynamic>{...?body};

        for (final file in files) {
          multipartMap[file.name] = await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          );
        }

        formData = FormData.fromMap(multipartMap);
      }

      /// === Construct Query Parameters ===
      final parameters = {
        ...?queryParams,
        'limit': AppConstants.paginationLimit.toString(),
        'lang': LanguageService.getLang(),
      };

      /// === Send Request ===
      final response = await _dio
          .request(
            url,
            data: isMultiData ? formData : body,
            queryParameters: parameters,
            options: Options(method: method, headers: headers),
          )
          .timeout(AppConstants.timeOut);

      printInfo(
        status: response.statusCode,
        url: url,
        title: 'Response Body',
        response.data,
      );

      /// ✅ Only allow statusCode == 200 as success
      if (response.statusCode == 200) {
        return PostDataHandle(
          hasError: false,
          data: fromJson == null ? response.data : fromJson(response.data),
          statusCode: response.statusCode,
        );
      } else {
        return PostDataHandle(
          hasError: true,
          message: AppErrorState.serverExceptions,
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      return ExceptionsHandler.onDioException(e);
    } catch (e) {
      return PostDataHandle(
        hasError: true,
        message: AppErrorState.serverExceptions,
        statusCode: 500,
      );
    }
  }
}
