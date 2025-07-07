// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueryState<TData, TError> implements DiagnosticableTreeMixin {
  TData? get data;
  TError? get error;
  DateTime? get dataUpdatedAt;
  DateTime? get errorUpdatedAt;
  bool get isFetching;
  QueryStatus get status;
  bool get isInvalidated;
  FetchMeta? get fetchMeta;
  bool get isRefetchError;

  /// Create a copy of QueryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QueryStateCopyWith<TData, TError, QueryState<TData, TError>> get copyWith =>
      _$QueryStateCopyWithImpl<TData, TError, QueryState<TData, TError>>(
          this as QueryState<TData, TError>, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'QueryState<$TData, $TError>'))
      ..add(DiagnosticsProperty('data', data))
      ..add(DiagnosticsProperty('error', error))
      ..add(DiagnosticsProperty('dataUpdatedAt', dataUpdatedAt))
      ..add(DiagnosticsProperty('errorUpdatedAt', errorUpdatedAt))
      ..add(DiagnosticsProperty('isFetching', isFetching))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('isInvalidated', isInvalidated))
      ..add(DiagnosticsProperty('fetchMeta', fetchMeta))
      ..add(DiagnosticsProperty('isRefetchError', isRefetchError));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QueryState<TData, TError> &&
            const DeepCollectionEquality().equals(other.data, data) &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.dataUpdatedAt, dataUpdatedAt) ||
                other.dataUpdatedAt == dataUpdatedAt) &&
            (identical(other.errorUpdatedAt, errorUpdatedAt) ||
                other.errorUpdatedAt == errorUpdatedAt) &&
            (identical(other.isFetching, isFetching) ||
                other.isFetching == isFetching) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isInvalidated, isInvalidated) ||
                other.isInvalidated == isInvalidated) &&
            (identical(other.fetchMeta, fetchMeta) ||
                other.fetchMeta == fetchMeta) &&
            (identical(other.isRefetchError, isRefetchError) ||
                other.isRefetchError == isRefetchError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(data),
      const DeepCollectionEquality().hash(error),
      dataUpdatedAt,
      errorUpdatedAt,
      isFetching,
      status,
      isInvalidated,
      fetchMeta,
      isRefetchError);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'QueryState<$TData, $TError>(data: $data, error: $error, dataUpdatedAt: $dataUpdatedAt, errorUpdatedAt: $errorUpdatedAt, isFetching: $isFetching, status: $status, isInvalidated: $isInvalidated, fetchMeta: $fetchMeta, isRefetchError: $isRefetchError)';
  }
}

/// @nodoc
abstract mixin class $QueryStateCopyWith<TData, TError, $Res> {
  factory $QueryStateCopyWith(QueryState<TData, TError> value,
          $Res Function(QueryState<TData, TError>) _then) =
      _$QueryStateCopyWithImpl;
  @useResult
  $Res call(
      {TData? data,
      TError? error,
      DateTime? dataUpdatedAt,
      DateTime? errorUpdatedAt,
      bool isFetching,
      QueryStatus status,
      bool isInvalidated,
      FetchMeta? fetchMeta,
      bool isRefetchError});
}

/// @nodoc
class _$QueryStateCopyWithImpl<TData, TError, $Res>
    implements $QueryStateCopyWith<TData, TError, $Res> {
  _$QueryStateCopyWithImpl(this._self, this._then);

  final QueryState<TData, TError> _self;
  final $Res Function(QueryState<TData, TError>) _then;

  /// Create a copy of QueryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? error = freezed,
    Object? dataUpdatedAt = freezed,
    Object? errorUpdatedAt = freezed,
    Object? isFetching = null,
    Object? status = null,
    Object? isInvalidated = null,
    Object? fetchMeta = freezed,
    Object? isRefetchError = null,
  }) {
    return _then(_self.copyWith(
      data: freezed == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as TData?,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as TError?,
      dataUpdatedAt: freezed == dataUpdatedAt
          ? _self.dataUpdatedAt
          : dataUpdatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      errorUpdatedAt: freezed == errorUpdatedAt
          ? _self.errorUpdatedAt
          : errorUpdatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isFetching: null == isFetching
          ? _self.isFetching
          : isFetching // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as QueryStatus,
      isInvalidated: null == isInvalidated
          ? _self.isInvalidated
          : isInvalidated // ignore: cast_nullable_to_non_nullable
              as bool,
      fetchMeta: freezed == fetchMeta
          ? _self.fetchMeta
          : fetchMeta // ignore: cast_nullable_to_non_nullable
              as FetchMeta?,
      isRefetchError: null == isRefetchError
          ? _self.isRefetchError
          : isRefetchError // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [QueryState].
extension QueryStatePatterns<TData, TError> on QueryState<TData, TError> {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_QueryState<TData, TError> value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _QueryState() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_QueryState<TData, TError> value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _QueryState():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_QueryState<TData, TError> value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _QueryState() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            TData? data,
            TError? error,
            DateTime? dataUpdatedAt,
            DateTime? errorUpdatedAt,
            bool isFetching,
            QueryStatus status,
            bool isInvalidated,
            FetchMeta? fetchMeta,
            bool isRefetchError)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _QueryState() when $default != null:
        return $default(
            _that.data,
            _that.error,
            _that.dataUpdatedAt,
            _that.errorUpdatedAt,
            _that.isFetching,
            _that.status,
            _that.isInvalidated,
            _that.fetchMeta,
            _that.isRefetchError);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            TData? data,
            TError? error,
            DateTime? dataUpdatedAt,
            DateTime? errorUpdatedAt,
            bool isFetching,
            QueryStatus status,
            bool isInvalidated,
            FetchMeta? fetchMeta,
            bool isRefetchError)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _QueryState():
        return $default(
            _that.data,
            _that.error,
            _that.dataUpdatedAt,
            _that.errorUpdatedAt,
            _that.isFetching,
            _that.status,
            _that.isInvalidated,
            _that.fetchMeta,
            _that.isRefetchError);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            TData? data,
            TError? error,
            DateTime? dataUpdatedAt,
            DateTime? errorUpdatedAt,
            bool isFetching,
            QueryStatus status,
            bool isInvalidated,
            FetchMeta? fetchMeta,
            bool isRefetchError)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _QueryState() when $default != null:
        return $default(
            _that.data,
            _that.error,
            _that.dataUpdatedAt,
            _that.errorUpdatedAt,
            _that.isFetching,
            _that.status,
            _that.isInvalidated,
            _that.fetchMeta,
            _that.isRefetchError);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _QueryState<TData, TError> extends QueryState<TData, TError>
    with DiagnosticableTreeMixin {
  const _QueryState(
      {this.data,
      this.error,
      this.dataUpdatedAt,
      this.errorUpdatedAt,
      this.isFetching = false,
      this.status = QueryStatus.loading,
      this.isInvalidated = false,
      this.fetchMeta,
      this.isRefetchError = false})
      : super._();

  @override
  final TData? data;
  @override
  final TError? error;
  @override
  final DateTime? dataUpdatedAt;
  @override
  final DateTime? errorUpdatedAt;
  @override
  @JsonKey()
  final bool isFetching;
  @override
  @JsonKey()
  final QueryStatus status;
  @override
  @JsonKey()
  final bool isInvalidated;
  @override
  final FetchMeta? fetchMeta;
  @override
  @JsonKey()
  final bool isRefetchError;

  /// Create a copy of QueryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$QueryStateCopyWith<TData, TError, _QueryState<TData, TError>>
      get copyWith =>
          __$QueryStateCopyWithImpl<TData, TError, _QueryState<TData, TError>>(
              this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'QueryState<$TData, $TError>'))
      ..add(DiagnosticsProperty('data', data))
      ..add(DiagnosticsProperty('error', error))
      ..add(DiagnosticsProperty('dataUpdatedAt', dataUpdatedAt))
      ..add(DiagnosticsProperty('errorUpdatedAt', errorUpdatedAt))
      ..add(DiagnosticsProperty('isFetching', isFetching))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('isInvalidated', isInvalidated))
      ..add(DiagnosticsProperty('fetchMeta', fetchMeta))
      ..add(DiagnosticsProperty('isRefetchError', isRefetchError));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _QueryState<TData, TError> &&
            const DeepCollectionEquality().equals(other.data, data) &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.dataUpdatedAt, dataUpdatedAt) ||
                other.dataUpdatedAt == dataUpdatedAt) &&
            (identical(other.errorUpdatedAt, errorUpdatedAt) ||
                other.errorUpdatedAt == errorUpdatedAt) &&
            (identical(other.isFetching, isFetching) ||
                other.isFetching == isFetching) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isInvalidated, isInvalidated) ||
                other.isInvalidated == isInvalidated) &&
            (identical(other.fetchMeta, fetchMeta) ||
                other.fetchMeta == fetchMeta) &&
            (identical(other.isRefetchError, isRefetchError) ||
                other.isRefetchError == isRefetchError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(data),
      const DeepCollectionEquality().hash(error),
      dataUpdatedAt,
      errorUpdatedAt,
      isFetching,
      status,
      isInvalidated,
      fetchMeta,
      isRefetchError);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'QueryState<$TData, $TError>(data: $data, error: $error, dataUpdatedAt: $dataUpdatedAt, errorUpdatedAt: $errorUpdatedAt, isFetching: $isFetching, status: $status, isInvalidated: $isInvalidated, fetchMeta: $fetchMeta, isRefetchError: $isRefetchError)';
  }
}

/// @nodoc
abstract mixin class _$QueryStateCopyWith<TData, TError, $Res>
    implements $QueryStateCopyWith<TData, TError, $Res> {
  factory _$QueryStateCopyWith(_QueryState<TData, TError> value,
          $Res Function(_QueryState<TData, TError>) _then) =
      __$QueryStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {TData? data,
      TError? error,
      DateTime? dataUpdatedAt,
      DateTime? errorUpdatedAt,
      bool isFetching,
      QueryStatus status,
      bool isInvalidated,
      FetchMeta? fetchMeta,
      bool isRefetchError});
}

/// @nodoc
class __$QueryStateCopyWithImpl<TData, TError, $Res>
    implements _$QueryStateCopyWith<TData, TError, $Res> {
  __$QueryStateCopyWithImpl(this._self, this._then);

  final _QueryState<TData, TError> _self;
  final $Res Function(_QueryState<TData, TError>) _then;

  /// Create a copy of QueryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? data = freezed,
    Object? error = freezed,
    Object? dataUpdatedAt = freezed,
    Object? errorUpdatedAt = freezed,
    Object? isFetching = null,
    Object? status = null,
    Object? isInvalidated = null,
    Object? fetchMeta = freezed,
    Object? isRefetchError = null,
  }) {
    return _then(_QueryState<TData, TError>(
      data: freezed == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as TData?,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as TError?,
      dataUpdatedAt: freezed == dataUpdatedAt
          ? _self.dataUpdatedAt
          : dataUpdatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      errorUpdatedAt: freezed == errorUpdatedAt
          ? _self.errorUpdatedAt
          : errorUpdatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isFetching: null == isFetching
          ? _self.isFetching
          : isFetching // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as QueryStatus,
      isInvalidated: null == isInvalidated
          ? _self.isInvalidated
          : isInvalidated // ignore: cast_nullable_to_non_nullable
              as bool,
      fetchMeta: freezed == fetchMeta
          ? _self.fetchMeta
          : fetchMeta // ignore: cast_nullable_to_non_nullable
              as FetchMeta?,
      isRefetchError: null == isRefetchError
          ? _self.isRefetchError
          : isRefetchError // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
