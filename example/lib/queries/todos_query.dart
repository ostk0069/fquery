import 'package:fquery/fquery.dart';

import '../models/todos.dart';

final todosQuery = createQuery<List<Todo>>(
  ['todos'],
  TodosAPI.getInstance().getAll,
);
