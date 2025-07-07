import 'package:fquery/src/query_key.dart';
import 'package:fquery/src/observer.dart';
import 'package:fquery/src/query.dart' show RefetchOnMount;

/// A configuration object that bundles the query key, fetcher, and all query options.
/// This can be passed to useQuery for cleaner code organization.
class QueryConfig<TData> {
  final RawQueryKey queryKey;
  final QueryFn<TData> fetcher;
  final bool enabled;
  final RefetchOnMount? refetchOnMount;
  final Duration? staleDuration;
  final Duration? cacheDuration;
  final Duration? refetchInterval;
  final int? retryCount;
  final Duration? retryDelay;

  const QueryConfig({
    required this.queryKey,
    required this.fetcher,
    this.enabled = true,
    this.refetchOnMount,
    this.staleDuration,
    this.cacheDuration,
    this.refetchInterval,
    this.retryCount,
    this.retryDelay,
  });
}

/// Creates a query configuration that bundles the query key, fetcher, and options.
/// 
/// Example:
/// ```dart
/// final postsQuery = createQuery(
///   ['posts'], 
///   () => fetchPosts(),
///   enabled: true,
///   refetchInterval: Duration(seconds: 5),
/// );
/// 
/// // Then use it with useQuery:
/// final result = useQuery(postsQuery);
/// ```
QueryConfig<TData> createQuery<TData>(
  RawQueryKey queryKey,
  QueryFn<TData> fetcher, {
  bool enabled = true,
  RefetchOnMount? refetchOnMount,
  Duration? staleDuration,
  Duration? cacheDuration,
  Duration? refetchInterval,
  int? retryCount,
  Duration? retryDelay,
}) {
  return QueryConfig<TData>(
    queryKey: queryKey,
    fetcher: fetcher,
    enabled: enabled,
    refetchOnMount: refetchOnMount,
    staleDuration: staleDuration,
    cacheDuration: cacheDuration,
    refetchInterval: refetchInterval,
    retryCount: retryCount,
    retryDelay: retryDelay,
  );
}

