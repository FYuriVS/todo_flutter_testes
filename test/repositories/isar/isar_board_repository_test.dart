import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo/models/task.dart';
import 'package:todo/repositories/board_repository.dart';
import 'package:todo/repositories/isar/isar_board_repository.dart';
import 'package:todo/repositories/isar/isar_datasource.dart';
import 'package:todo/repositories/isar/task_model.dart';

class IsarDatasourceMock extends Mock implements IsarDatasource {}

void main() {
  late IsarDatasource datasource;
  late BoardRepository repository;
  setUp(() {
    datasource = IsarDatasourceMock();
    repository = IsarBoardRepository(datasource);
  });

  test('fetch', () async {
    when(() => datasource.getTasks()).thenAnswer((_) async => [
          TaskModel()..id = 1,
        ]);

    final tasks = await repository.fetch();
    expect(tasks.length, 1);
  });
  test('update', () async {
    when(() => datasource.deleteAllTask()).thenAnswer((_) async => []);
    when(() => datasource.putAllTasks(any())).thenAnswer((_) async => []);

    final tasks = await repository.update([
      const Task(id: -1, description: '', check: false),
      const Task(id: 2, description: '', check: false),
    ]);
    expect(tasks.length, 2);
  });
}
