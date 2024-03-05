import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';

@freezed
class Todo with _$Todo {
  factory Todo({
    required String todoId,
    required String title,
    // 初期値を設定できる
    @Default(false) bool isCompleted,
    required DateTime createdAt,
  }) = _Todo;
}
