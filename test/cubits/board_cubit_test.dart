import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo/cubits/board_cubit.dart';
import 'package:todo/models/task.dart';
import 'package:todo/repositories/board_repository.dart';
import 'package:todo/states/board_state.dart';

class BoardRepositoryMock extends Mock implements BoardRepository {}

void main() {
  late BoardRepositoryMock repository = BoardRepositoryMock();
  late BoardCubit cubit;
  setUp(() {
    repository = BoardRepositoryMock();
    cubit = BoardCubit(repository);
  });
  group(
    'fetchTask |',
    () {
      test(
        'deve pegar todas as tasks',
        () async {
          when(() => repository.fetch()).thenAnswer(
            (_) async => [
              const Task(id: 1, description: '', check: true),
            ],
          );

          expect(
            cubit.stream,
            emitsInOrder(
              [
                isA<LoadingBoardState>(),
                isA<GettedTasksBoarsState>(),
              ],
            ),
          );
          await cubit.fetchTasks();
        },
      );

      test(
        'deve retornar estado de erro ao falhar',
        () async {
          when(() => repository.fetch()).thenThrow(Exception('Error'));

          expect(
            cubit.stream,
            emitsInOrder(
              [
                isA<LoadingBoardState>(),
                isA<FailureBoardState>(),
              ],
            ),
          );

          await cubit.fetchTasks();
        },
      );
    },
  );

  group(
    'addTask |',
    () {
      test(
        'deve adicionar uma task',
        () async {
          when(() => repository.update(any())).thenAnswer((_) async => []);

          expect(
            cubit.stream,
            emitsInOrder(
              [
                isA<GettedTasksBoarsState>(),
              ],
            ),
          );
          const task = Task(id: 1, description: 'description', check: false);
          await cubit.addTask(task);
          final state = cubit.state as GettedTasksBoarsState;
          expect(state.tasks.length, 1);
          expect(state.tasks, [task]);
        },
      );

      test(
        'deve retornar estado de erro ao falhar',
        () async {
          when(() => repository.update(any())).thenThrow(Exception('Error'));

          expect(
            cubit.stream,
            emitsInOrder(
              [
                isA<FailureBoardState>(),
              ],
            ),
          );
          const task = Task(id: 1, description: 'description', check: false);
          await cubit.addTask(task);
        },
      );
    },
  );

  group(
    'removeTask |',
    () {
      test(
        'deve remover uma task',
        () async {
          when(() => repository.update(any())).thenAnswer((_) async => []);
          const task = Task(id: 1, description: 'description', check: false);
          cubit.addTasks([task]);
          expect((cubit.state as GettedTasksBoarsState).tasks.length, 1);

          expect(
            cubit.stream,
            emitsInOrder(
              [
                isA<GettedTasksBoarsState>(),
              ],
            ),
          );

          await cubit.removeTask(task);
          final state = cubit.state as GettedTasksBoarsState;
          expect(state.tasks.length, 0);
        },
      );

      test(
        'deve retornar estado de erro ao falhar',
        () async {
          when(() => repository.update(any())).thenThrow(Exception('Error'));
          const task = Task(id: 1, description: 'description', check: false);
          cubit.addTasks([task]);

          expect(
            cubit.stream,
            emitsInOrder(
              [
                isA<FailureBoardState>(),
              ],
            ),
          );

          await cubit.removeTask(task);
        },
      );
    },
  );

  group(
    'checkTask |',
    () {
      test(
        'deve checar uma task',
        () async {
          when(() => repository.update(any())).thenAnswer((_) async => []);
          const task = Task(id: 1, description: 'description', check: false);
          cubit.addTasks([task]);
          expect((cubit.state as GettedTasksBoarsState).tasks.length, 1);
          expect(
              (cubit.state as GettedTasksBoarsState).tasks.first.check, false);

          expect(
            cubit.stream,
            emitsInOrder(
              [
                isA<GettedTasksBoarsState>(),
              ],
            ),
          );

          await cubit.checkTask(task);
          final state = cubit.state as GettedTasksBoarsState;
          expect(state.tasks.length, 1);
          expect(state.tasks.first.check, true);
        },
      );

      test(
        'deve retornar estado de erro ao falhar',
        () async {
          when(() => repository.update(any())).thenThrow(Exception('Error'));
          const task = Task(id: 1, description: 'description', check: false);
          cubit.addTasks([task]);

          expect(
            cubit.stream,
            emitsInOrder(
              [
                isA<FailureBoardState>(),
              ],
            ),
          );

          await cubit.checkTask(task);
        },
      );
    },
  );
}
