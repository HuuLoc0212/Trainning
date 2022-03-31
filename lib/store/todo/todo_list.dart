import 'package:mobx/mobx.dart';
import 'package:start/store/todo/todo.dart';

part 'todo_list.g.dart';

enum VisibilityFilter {all, pending, completed}

class TodoList =  _TodoList with _$TodoList;

abstract class _TodoList with Store{
  @observable
  ObservableList<Todo> todos = ObservableList<Todo>();

  @observable
  VisibilityFilter filter = VisibilityFilter.all;

  @action
  Future<ObservableList<Todo>> initTodos() async{
    await Future.delayed(const Duration(seconds: 2));
    for(int i = 0; i < 10; i++){
      todos.add(Todo("Task - " + i.toString()));
      print("Task - " + i.toString());
    }
    return todos;
  }

  @action
  removeTodosAt(int index){
    todos.removeAt(index);
  }

  @action
  addTodo(String des){
    todos.add(Todo(des));
  }

  @action
  editTodo(int index, String des, bool done){
    todos[index].description = des;
    todos[index].done = done;
  }

  @action
  editStatusTodo(int index, bool done){
    todos[index].done = done;
    print(done.toString());
  }
}
