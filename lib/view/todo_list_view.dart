import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_todo/controller/todo_provider.dart';
import 'package:riverpod_todo/model/todo.dart';

class TodoListView extends ConsumerWidget {
  const TodoListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoContentTextController = TextEditingController();
    final todoList = ref.watch(todoNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo'),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: todoContentTextController,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final content = todoContentTextController.text;
        
                      todoContentTextController.clear();
        
                      final id = (todoList.isEmpty)
                          ? '1'
                          : (int.parse(todoList.last.todoId) + 1).toString();
        
                      final todo = Todo(
                        todoId: id,
                        title: 'test',
                        createdAt: DateTime.now(),
                        content: content,
                      );
        
                      ref.read(todoNotifierProvider.notifier).addTodo(todo);
        
                      FocusScope.of(context).unfocus();
                    },
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
                    final formattedDate = DateFormat('yyyy/MM/dd HH:mm:ss')
                        .format(todoList[index].createdAt);
                    // 右でも左でもスワイプするとListの要素が削除される。
                    return Dismissible(
                      key: Key(todoList[index].todoId),
                      onDismissed: (direction) {
                        ref.read(todoNotifierProvider.notifier)
                            .removeTodo(todoList[index].todoId);
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
                        subtitle: Text(formattedDate),
                        trailing: Checkbox(
                          value: todoList[index].isCompleted,
                          onChanged: (_) {
                            ref.read(todoNotifierProvider.notifier)
                                .toggleCompleted(todoList[index].todoId);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
