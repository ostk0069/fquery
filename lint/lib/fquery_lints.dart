import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'src/rules/use_query_key_rule.dart';

PluginBase createPlugin() => _FqueryLints();

class _FqueryLints extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        UseQueryKeyRule(),
      ];
}