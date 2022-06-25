import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:todo/core/Failures/todo_failures.dart';
import 'package:todo/domain/entities/todo.dart';
import 'package:todo/domain/repositories/todo_repository.dart';

part 'observer_event.dart';
part 'observer_state.dart';

class ObserverBloc extends Bloc<ObserverEvent, ObserverState> {
  final TodoRepository todoRepository;

  StreamSubscription<Either<TodoFailure, List<Todo>>>? _todoStreamSub;

  ObserverBloc({required this.todoRepository}) : super(ObserverInitial()) {
    on<ObserverAllEvent>((event, emit) async {
      emit(ObserverLoading());
      await _todoStreamSub?.cancel();
      _todoStreamSub = todoRepository.watchAll().listen((failureOrTodos) =>
          add(TodosUpdatedEvent(failureOrTodos: failureOrTodos)));
      // TODO: implement event handler
    });

    on<TodosUpdatedEvent>((event, emit) {
      event.failureOrTodos.fold(
          (failures) => emit(ObserverFailure(todoFailure: failures)),
          (todos) => emit(ObserverSuccess(todos: todos)));
    });
  }

  @override
  Future<void> close() async {
    await _todoStreamSub?.cancel();
    return super.close();
  }
}
