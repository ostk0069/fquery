import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/src/query.dart';
import 'package:fquery/src/hooks/use_query.dart';
import 'package:fquery/src/observer.dart';
import 'package:fquery/src/query_key.dart';
import 'package:fquery/src/create_query.dart';

class QueryBuilder<TData, TError> extends HookWidget {
  final Widget Function(BuildContext, UseQueryResult<TData, TError, TData>) builder;
  final RawQueryKey queryKey;
  final QueryFn<TData> queryFn;
  final bool enabled;

  final RefetchOnMount? refetchOnMount;
  final Duration? staleDuration;
  final Duration? cacheDuration;
  final Duration? refetchInterval;
  final int? retryCount;
  final Duration? retryDelay;

  const QueryBuilder(
    this.queryKey,
    this.queryFn, {
    super.key,
    required this.builder,
    this.enabled = true,
    this.refetchOnMount,
    this.staleDuration,
    this.cacheDuration,
    this.refetchInterval,
    this.retryCount,
    this.retryDelay,
  });

  @override
  Widget build(BuildContext context) {
    // Create QueryConfig from the provided parameters
    final queryConfig = QueryConfig<TData>(
      queryKey: queryKey,
      fetcher: queryFn,
      enabled: enabled,
      refetchOnMount: refetchOnMount,
      staleDuration: staleDuration,
      cacheDuration: cacheDuration,
      refetchInterval: refetchInterval,
      retryCount: retryCount,
      retryDelay: retryDelay,
    );
    
    final query = useQuery<TData, TError>(queryConfig);

    return Builder(builder: (context) {
      return builder(context, query);
    });
  }
}
