import 'package:equatable/equatable.dart';

import '../constants/app_flow_sate.dart';

class DataHandle<T> extends Equatable {
  final T? data;
  final String result;
  final String? type;
  final T? temp;
  final int filterPage;
  final String? nextUrl;
  final bool? openPage;

  const DataHandle({
    this.data,
    this.result = AppFlowState.initial,
    this.type,
    this.temp,
    this.filterPage = 1,
    this.nextUrl,
    this.openPage,
  });

  /// Creates a modified copy of the current object.
  DataHandle<T> copyWith({
    T? data,
    String? result,
    String? type,
    T? temp,
    int? filterPage,
    String? nextUrl,
    bool? openPage,
    bool resetNextUrl = false,
    bool resetData = false,
  }) {
    return DataHandle<T>(
      data: resetData ? data : data ?? this.data,
      result: result ?? this.result,
      type: type ?? this.type,
      temp: temp ?? this.temp,
      filterPage: filterPage ?? this.filterPage,
      nextUrl: resetNextUrl ? nextUrl : nextUrl ?? this.nextUrl,
      openPage: openPage ?? this.openPage,
    );
  }

  @override
  List<Object?> get props => [
    data,
    result,
    type,
    temp,
    filterPage,
    nextUrl,
    openPage,
  ];
}

class PostDataHandle<T> extends Equatable {
  final String? message;
  final bool hasError;
  final T? data;
  final T? temp;
  final String? url;
  final bool? openPage;
  final int? statusCode;

  const PostDataHandle({
    required this.hasError,
    this.message,
    this.data,
    this.temp,
    this.url,
    this.openPage,
    this.statusCode,
  });

  @override
  List<Object?> get props => [
    data,
    message,
    hasError,
    temp,
    url,
    openPage,
    statusCode,
  ];
}
