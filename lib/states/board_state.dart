import 'package:todo/models/task.dart';

sealed class BoardState {}

class LoadingBoardState implements BoardState {}

class GettedTasksBoarsState implements BoardState {
  final List<Task> tasks;

  GettedTasksBoarsState({required this.tasks});
}

class EmptyBoardState extends GettedTasksBoarsState {
  EmptyBoardState() : super(tasks: []);
}

class FailureBoardState implements BoardState {
  final String message;

  FailureBoardState({required this.message});
}
