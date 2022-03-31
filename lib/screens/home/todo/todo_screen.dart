import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:mobx/mobx.dart';
import 'package:start/store/todo/todo.dart';
import 'package:start/store/todo/todo_list.dart';
import 'package:start/widgets/app.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../constants/constants.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TodoList _todoList = TodoList();
  late Future<ObservableList<Todo>> _todos;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _descriptionController = TextEditingController();
  final String _addAction = 'add';
  final String _updateAction = 'update';

  @override
  void initState() {
    _todos = _todoList.initTodos(); //create 10 item
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: createAppbar(context, title: 'Todo List'),
        body: FutureBuilder<ObservableList<Todo>>(
            future: _todos,
            builder: (BuildContext context,
                AsyncSnapshot<ObservableList<Todo>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                print('waiting');
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  print('Count: ' + (snapshot.data?.length.toString() ?? '0'));
                  return Container(
                    color: primaryColor,
                    child: Container(
                      decoration: BoxDecoration(
                          color: secondColor,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20.0))),
                      child: _buildListView(),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Text('Error');
                }
              }
              return Container();
            }),
        floatingActionButton: _buildFloatingButton(),
      ),
    );
  }

  ///Body:
  Widget _buildListView() {
    return Observer(
      builder: (_) => ListView.separated(
        reverse: false,
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (context, index) => const Divider(height: 1.0),
        itemCount: _todoList.todos.length,
        itemBuilder: (context, index) => _buildListViewItem(index),
      ),
    );
  }

  //Items
  Widget _buildListViewItem(index) {
    return Observer(
      builder: (_) => Slidable(
        endActionPane: ActionPane(
          extentRatio: 0.20,
          motion: const BehindMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => _showAddOrUpdateDialog(context,
                  index: index, action: _updateAction),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: Icons.edit_rounded,
              label: 'Update',
            ),
          ],
        ),
        child: ListTile(
          onLongPress: () => _showAlertDialog(index),
          /*onTap: () => _showAddOrUpdateDialog(context,
              index: index, action: _updateAction),*/
          leading: SizedBox(
            height: double.infinity,
            child: IconButton(
              icon: Icon(_todoList.todos[index].done
                  ? Icons.check_box_outlined
                  : Icons.check_box_outline_blank),
              onPressed: () {
                print('click leading');
                _pressUpdateButton(
                    status: !_todoList.todos[index!].done, index: index);
              },
            ),
          ),
          title: Text(
            _todoList.todos[index].description,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            _todoList.todos[index].description,
            style: const TextStyle(fontSize: 15),
          ),
          trailing: const SizedBox(
            height: double.infinity,
            child: Icon(Icons.arrow_forward_ios, size: 15),
          ),
        ),
      ),
    );
  }

  ///Floating Action Button
  Widget _buildFloatingButton() {
    return FloatingActionButton(
      onPressed: () => _showAddOrUpdateDialog(context, action: _addAction),
      //_todoList.addTodo('des'),
      // Navigator.pushNamed(context, '/home/additem'),
      backgroundColor: primaryColor,
      elevation: 0.0,
      child: const Icon(Icons.add),
    );
  }

  ///Dialog
  //Delete
  _showAlertDialog(int index) {
    showDialog(
      context: _scaffoldKey.currentContext!,
      builder: (context) => AlertDialog(
        title: const Text('Delete item!'),
        content: const Text('Do you want to delete this item'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () async {
              await _todoList.removeTodosAt(index);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  ///Add or Update
  Widget _buildDialogButton(
      {required String text,
      required Color? color,
      required Function()? onPressed}) {
    return Expanded(
        child: ElevatedButton(
      child: Text(text),
      style: ElevatedButton.styleFrom(
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        primary: color,
      ),
      onPressed: onPressed,
    ));
  }

  _pressUpdateButton({required int index, required bool status}) async {
    await _todoList.editStatusTodo(index, status);
  }

  _showAddOrUpdateDialog(
    BuildContext context, {
    required String action,
    int? index,
  }) {
    bool status = false;

    if (action == _updateAction) {
      status = _todoList.todos[index!].done;
      _descriptionController.text = _todoList.todos[index].description;
      print(_descriptionController.text);
    } else if (action == _addAction) {
      _descriptionController.text = '';
    }

    showDialog(
      context: _scaffoldKey.currentContext!,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                //_buildTopSideDialog(action: action, status: status),
                Row(
                  mainAxisAlignment: action == _addAction
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(action == _addAction ? 'Add New Todo' : 'Update Todo',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                    action == _addAction
                        ? const SizedBox(height: 0.0, width: 0.0)
                        : FlutterSwitch(
                            width: 75.0,
                            height: 30.0,
                            valueFontSize: 10.0,
                            toggleSize: 25.0,
                            value: status,
                            borderRadius: 30.0,
                            padding: 5.0,
                            showOnOff: true,
                            activeColor: Colors.green,
                            inactiveColor: primaryColor,
                            activeText: 'Done',
                            inactiveText: 'Not Yet',
                            onToggle: (val) {
                              setState(() {
                                status = val;
                              });
                            },
                          )
                  ],
                ),
                const SizedBox(height: 10.0),
                _buildCenterSide(),
                const SizedBox(height: 5.0),
                _buildBottomSide(action: action, status: status, index: index)
              ],
            ),
          ),
        ),
      ),
    );
  }

  //TOP - TITLE
  Widget _buildTopSideDialog({required String action, required bool status}) {
    return Row(
      mainAxisAlignment: action == _addAction
          ? MainAxisAlignment.center
          : MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(action == _addAction ? 'Add New Todo' : 'Update Todo',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        action == _addAction
            ? const SizedBox(height: 0.0, width: 0.0)
            : FlutterSwitch(
                width: 75.0,
                height: 30.0,
                valueFontSize: 10.0,
                toggleSize: 25.0,
                value: status,
                borderRadius: 30.0,
                padding: 5.0,
                showOnOff: true,
                activeColor: Colors.green,
                inactiveColor: primaryColor,
                activeText: 'Done',
                inactiveText: 'Not Yet',
                onToggle: (val) {
                  setState(() {
                    status = val;
                  });
                },
              )
      ],
    );
  }

  //CENTER - INPUT
  Widget _buildCenterSide() {
    return TextField(
      controller: _descriptionController,
      minLines: 1,
      decoration: InputDecoration(
        hintText: 'Enter todo',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        focusedBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      ),
      cursorColor: Colors.grey,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
    );
  }

  //BOTTOM - BUTTON
  Widget _buildBottomSide(
      {required String action, required bool status, int? index}) {
    return Row(
      children: <Widget>[
        _buildDialogButton(
          text: 'Back',
          color: Colors.black.withOpacity(0.2),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        const SizedBox(width: 8.0),
        _buildDialogButton(
          text: action == _addAction ? 'Add' : 'Update',
          color: Colors.redAccent.withOpacity(0.7),
          onPressed: /*onPressed*/ () async {
            if (_descriptionController.text.isNotEmpty) {
              if (action == _addAction) {
                await _todoList.addTodo(_descriptionController.text);
                _descriptionController.clear();
                //Navigator.of(context).pop();
              } else if (action == _updateAction) {
                await _todoList.editTodo(
                    index!, _descriptionController.text, status);
              }
              _descriptionController.clear();
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
