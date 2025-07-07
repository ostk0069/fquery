import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:fquery/src/observer.dart';
import 'package:fquery/src/query_key.dart';

class QueryBuilder<TData, TError, TSelected> extends HookWidget {
  final Widget Function(BuildContext, UseQueryResult<TData, TError, TSelected>) builder;
  final RawQueryKey queryKey;
  final QueryFn<TData> queryFn;
  final bool enabled;
  final TSelected Function(TData)? select;

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
    this.select,
    this.refetchOnMount,
    this.staleDuration,
    this.cacheDuration,
    this.refetchInterval,
    this.retryCount,
    this.retryDelay,
  });

  @override
  Widget build(BuildContext context) {
    final query = select != null
        ? useQueryWithSelect<TData, TError, TSelected>(
            queryKey,
            queryFn,
            cacheDuration: cacheDuration,
            enabled: enabled,
            refetchInterval: refetchInterval,
            refetchOnMount: refetchOnMount,
            staleDuration: staleDuration,
            retryCount: retryCount,
            retryDelay: retryDelay,
            select: select,
          )
        : useQuery<TData, TError>(
            queryKey,
            queryFn,
            cacheDuration: cacheDuration,
            enabled: enabled,
            refetchInterval: refetchInterval,
            refetchOnMount: refetchOnMount,
            staleDuration: staleDuration,
            retryCount: retryCount,
            retryDelay: retryDelay,
          ) as UseQueryResult<TData, TError, TSelected>;

    return Builder(builder: (context) {
      return builder(context, query);
    });
  }
}
