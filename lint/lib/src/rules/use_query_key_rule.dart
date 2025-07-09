import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:analyzer/error/error.dart' hide LintCode;

class UseQueryKeyRule extends DartLintRule {
  UseQueryKeyRule() : super(code: _code);

  static const _code = LintCode(
    name: 'use_query_key_directory_structure',
    problemMessage: 'createQuery keys should match the file path structure. '
        'For a file at lib/queries/posts_query.dart, use [\'posts\']. '
        'For lib/hoge/queries/hoge_query.dart, use [\'hoge\', \'hoge\'].',
    correctionMessage: 'Update your query key to match the file path structure.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addMethodInvocation((node) {
      // Check if this is a createQuery call
      if (node.methodName.name != 'createQuery') return;

      // Get the file path relative to lib/
      final filePath = resolver.path;
      final libIndex = filePath.indexOf('/lib/');
      if (libIndex == -1) return;

      final relativePath = filePath.substring(libIndex + 5); // Remove '/lib/'
      
      // Extract expected key from file path
      final expectedKey = _extractExpectedKey(relativePath);
      if (expectedKey.isEmpty) return;

      // Check if createQuery has the correct key
      final arguments = node.argumentList.arguments;
      if (arguments.isEmpty) return;

      final firstArg = arguments.first;
      
      // Check if the first argument is a list literal (the key)
      if (firstArg is ListLiteral) {
        _validateCreateQueryKey(
          firstArg,
          expectedKey,
          reporter,
          node,
        );
      }
    });
  }

  List<String> _extractExpectedKey(String relativePath) {
    // Remove .dart extension
    var path = relativePath.replaceAll('.dart', '');
    
    // Handle special cases:
    // 1. queries/posts_query.dart -> ['posts']
    // 2. hoge/queries/hoge_query.dart -> ['hoge', 'hoge']
    
    final parts = path.split('/');
    final expectedKey = <String>[];
    
    // Find if there's a 'queries' directory in the path
    final queriesIndex = parts.indexOf('queries');
    
    if (queriesIndex != -1) {
      // If there are directories before 'queries', include them
      if (queriesIndex > 0) {
        // Add all directories before 'queries'
        expectedKey.addAll(parts.sublist(0, queriesIndex));
      }
      
      // If there's a file after 'queries', extract its name
      if (queriesIndex + 1 < parts.length) {
        final fileName = parts[queriesIndex + 1];
        // Remove '_query' suffix if present
        final keyPart = fileName.replaceAll('_query', '');
        expectedKey.add(keyPart);
      }
    } else {
      // If no 'queries' directory, just use the file name without _query suffix
      if (parts.isNotEmpty) {
        final fileName = parts.last;
        final keyPart = fileName.replaceAll('_query', '');
        expectedKey.add(keyPart);
      }
    }
    
    return expectedKey;
  }

  void _validateCreateQueryKey(
    ListLiteral keyList,
    List<String> expectedKey,
    ErrorReporter reporter,
    MethodInvocation node,
  ) {
    final elements = keyList.elements;
    if (elements.isEmpty) {
      reporter.atNode(
        keyList,
        _code,
        data: ['Query key should not be empty.'],
      );
      return;
    }

    // Extract string literals from the key
    final actualKey = <String>[];
    for (final element in elements) {
      if (element is StringLiteral) {
        actualKey.add(element.stringValue ?? '');
      } else {
        // Stop at non-string elements (like IDs)
        break;
      }
    }

    // Check if the actual key matches the expected key
    bool matches = true;
    if (actualKey.length < expectedKey.length) {
      matches = false;
    } else {
      for (int i = 0; i < expectedKey.length; i++) {
        if (actualKey[i] != expectedKey[i]) {
          matches = false;
          break;
        }
      }
    }

    if (!matches) {
      final suggestedKey = expectedKey.join('\', \'');
      reporter.atNode(
        keyList,
        _code,
        data: [
          'Expected key [\'$suggestedKey\'] based on file path.',
        ],
      );
    }
  }
}