import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fquery/fquery.dart';

typedef TestBuilder<T> = Widget Function(
  BuildContext context,
  UseQueryResult<T, dynamic, T> result,
);

typedef TestRefetchBuilder<T> = Widget Function(
  BuildContext context,
  UseQueryResult<T, dynamic, T> result,
  void Function() setRefetch,
);

class QueryTestHelper {
  static Widget buildTestApp({
    required QueryClient queryClient,
    required Widget child,
  }) {
    return QueryClientProvider(
      queryClient: queryClient,
      child: MaterialApp(
        home: child,
      ),
    );
  }

  static Widget buildQueryTest<T>({
    required QueryConfig<T> query,
    required TestBuilder<T> builder,
    QueryOptions? options,
  }) {
    return HookBuilder(
      builder: (context) {
        final UseQueryResult<T, dynamic, T> result;
        
        if (options?.enabled != null && options?.refetchOnMount != null) {
          result = useQuery(query, enabled: options!.enabled!, refetchOnMount: options.refetchOnMount!);
        } else if (options?.enabled != null) {
          result = useQuery(query, enabled: options!.enabled!);
        } else if (options?.refetchOnMount != null) {
          result = useQuery(query, refetchOnMount: options!.refetchOnMount!);
        } else {
          result = useQuery(query);
        }
        
        return builder(context, result);
      },
    );
  }

  static Widget buildRefetchTest<T>({
    required QueryConfig<T> query,
    required TestRefetchBuilder<T> builder,
    QueryOptions? options,
  }) {
    return HookBuilder(
      builder: (context) {
        final UseQueryResult<T, dynamic, T> result;
        
        if (options?.enabled != null && options?.refetchOnMount != null) {
          result = useQuery(query, enabled: options!.enabled!, refetchOnMount: options.refetchOnMount!);
        } else if (options?.enabled != null) {
          result = useQuery(query, enabled: options!.enabled!);
        } else if (options?.refetchOnMount != null) {
          result = useQuery(query, refetchOnMount: options!.refetchOnMount!);
        } else {
          result = useQuery(query);
        }
        
        return builder(context, result, () => result.refetch());
      },
    );
  }

  static Widget buildLoadingWidget() {
    return const CircularProgressIndicator();
  }

  static Widget buildErrorWidget(dynamic error) {
    return Text('Error: $error');
  }

  static Future<void> waitForQuery(
    WidgetTester tester, {
    Duration delay = const Duration(seconds: 3),
  }) async {
    await tester.pump(delay);
    await tester.pumpAndSettle();
  }

  static void expectLoading(WidgetTester tester) {
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  }

  static void expectNotLoading(WidgetTester tester) {
    expect(find.byType(CircularProgressIndicator), findsNothing);
  }
}

class QueryOptions {
  final bool? enabled;
  final RefetchOnMount? refetchOnMount;

  const QueryOptions({
    this.enabled,
    this.refetchOnMount,
  });

  List<dynamic> toArgs() {
    final args = <dynamic>[];
    if (enabled != null) args.add(enabled);
    if (refetchOnMount != null) args.add(refetchOnMount);
    return args;
  }
}

extension QueryResultTestExtensions<T> on UseQueryResult<T, dynamic, T> {
  Widget toTestWidget<TData>({
    Widget Function()? loading,
    Widget Function(dynamic error)? error,
    required Widget Function(TData data) data,
  }) {
    if (isLoading) {
      return loading?.call() ?? QueryTestHelper.buildLoadingWidget();
    }

    if (this.error != null) {
      return error?.call(this.error) ?? QueryTestHelper.buildErrorWidget(this.error);
    }

    return data(this.data as TData);
  }
}