import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo/model/todo.dart';

final todoListProvider = NotifierProvider<TodoListNotifier, List<Todo>>(
  TodoListNotifier.new,
);

class TodoListNotifier extends Notifier<List<Todo>> {
  void addTodo(Todo todo) {
    state = [...state, todo];
  }

  @override
  List<Todo> build() {
    return [];
  }

  void clearCompleted() {
    state = state.where((todo) => !todo.isCompleted).toList();
  }

  void removeTodo(String id) {
    state = state.where((todo) => todo.todoId != id).toList();
  }

  void toggleCompleted(String id) {
    state = state
        .map(
          (todo) => todo.todoId == id
              ? todo.copyWith(isCompleted: !todo.isCompleted)
              : todo,
        )
        .toList();
  }
}
