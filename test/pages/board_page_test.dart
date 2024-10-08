import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo/cubits/board_cubit.dart';
import 'package:todo/models/task.dart';
import 'package:todo/pages/board_page.dart';
import 'package:todo/repositories/board_repository.dart';

class BoardRepositoryMock extends Mock implements BoardRepository {}

void main() {
  late BoardRepositoryMock repository = BoardRepositoryMock();
  late BoardCubit cubit;
  setUp(() {
    repository = BoardRepositoryMock();
    cubit = BoardCubit(repository);
  });

  testWidgets(
    'board page with all tasks',
    (tester) async {
      when(() => repository.fetch()).thenAnswer(
          (_) async => [const Task(id: 1, description: '', check: false)]);

      await tester.pumpWidget(
        BlocProvider.value(
          value: cubit,
          child: const MaterialApp(
            home: BoardPage(),
          ),
        ),
      );

      expect(find.byKey(const Key('EmptyState')), findsOneWidget);
      await tester.pump(const Duration(seconds: 2));
      expect(find.byKey(const Key('GettedState')), findsOneWidget);
    },
  );
  testWidgets(
    'board page with empty tasks',
    (tester) async {
      when(() => repository.fetch()).thenAnswer((_) async => []);

      await tester.pumpWidget(
        BlocProvider.value(
          value: cubit,
          child: const MaterialApp(
            home: BoardPage(),
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 2));
      expect(find.byKey(const Key('EmptyState')), findsOneWidget);
    },
  );
  testWidgets(
    'board page with all tasks failure state',
    (tester) async {
      when(() => repository.fetch()).thenThrow(Exception("Error"));

      await tester.pumpWidget(
        BlocProvider.value(
          value: cubit,
          child: const MaterialApp(
            home: BoardPage(),
          ),
        ),
      );

      expect(find.byKey(const Key('EmptyState')), findsOneWidget);
      await tester.pump(const Duration(seconds: 2));
      expect(find.byKey(const Key('FailureState')), findsOneWidget);
    },
  );
}
