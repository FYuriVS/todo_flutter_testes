import 'package:todo/models/task.dart';
import 'package:todo/repositories/board_repository.dart';
import 'package:todo/repositories/isar/isar_datasource.dart';

class IsarBoardRepository implements BoardRepository {
  final IsarDatasource datasource;

  IsarBoardRepository(this.datasource);

  @override
  Future<List<Task>> fetch() async {
    final models = await datasource.getTasks();
    return models
        .map((e) => Task(
              id: e.id,
              description: e.description,
              check: e.check,
            ))
        .toList();
  }

  @override
  Future<List<Task>> update(List<Task> tasks) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
