import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo/controller/todo_provider.dart';
import 'package:riverpod_todo/model/todo.dart';

class TodoListPage extends ConsumerWidget {
  final todoContentTextController = TextEditingController();
  final todoContentTextFocusNode = FocusNode();
  TodoListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoList = ref.watch(todoListProvider);
    final todoListNotifier = ref.read(todoListProvider.notifier);

    // 追加ボタン押下
    void onPressedAddButton() {
      final content = todoContentTextController.text;
      todoContentTextController.clear();

      final id = (todoList.isEmpty)
          ? '1'
          : (int.parse(todoList.last.todoId) + 1).toString();

      final todo = Todo(
        todoId: id,
        title: '',
        createdAt: DateTime.now(),
        content: content,
      );

      todoListNotifier.addTodo(todo);

      FocusScope.of(context).requestFocus(todoContentTextFocusNode);
    }

    void onPressedDeleteButton(int index) {
      todoListNotifier.removeTodo(todoList[index].todoId);
    }

    void onPressedToggleButton(int index) {
      todoListNotifier.toggleCompleted(todoList[index].todoId);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: todoContentTextController,
                    focusNode: todoContentTextFocusNode,
                  ),
                ),
                ElevatedButton(
                  onPressed: onPressedAddButton,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: todoList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: Key(todoList[index].todoId),
                    onDismissed: (direction) {
                      onPressedDeleteButton(index);
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 16),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    child: ListTile(
                      title: Text(todoList[index].content),
                      subtitle: Text(todoList[index].createdAt.toString()),
                      trailing: Checkbox(
                        value: todoList[index].isCompleted,
                        onChanged: (_) => onPressedToggleButton(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
