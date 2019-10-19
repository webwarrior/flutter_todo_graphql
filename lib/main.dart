import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

void main() => runApp(TodoApp(

));

class TodoApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Todo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title} ) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<String> _todoItems = [];
  final TextStyle _biggerFont = TextStyle(fontSize: 18.0);

  var todos = new List<TodoItem>();


  // This will be called each time the + button is pressed
  void _addTodoItem(String task) {
    // Putting our code inside "setState" tells the app that our state has changed, and
    // it will automatically re-render the list
    if(task.length > 0){
      setState(() => todos.add(TodoItem(task: task,completed: false)));
    }
  }

  void _pushAddTodoScreen() {
    // Push this page onto the stack
    Navigator.of(context).push(
      // MaterialPageRoute will automatically animate the screen entry, as well
      // as adding a back button to close it
        new MaterialPageRoute(
            builder: (context) {
              return new Scaffold(
                  appBar: new AppBar(
                      title: new Text('Add a new task')
                  ),
                  body: new TextField(
                    autofocus: true,
                    onSubmitted: (val) {
                      _addTodoItem(val);
                      Navigator.pop(context); // Close the add todo screen
                    },
                    decoration: new InputDecoration(
                        hintText: 'Enter something to do...',
                        contentPadding: const EdgeInsets.all(16.0)
                    ),
                  )
              );
            }
        )
    );
  }

  // Much like _addTodoItem, this modifies the array of todo strings and
// notifies the app that the state has changed by using setState
  void _removeTodoItem(int index) {
    setState(() => todos.removeAt(index));
  }

  void _updateTodoItem(int index) {
    setState(() => todos[index].completed = !todos[index].completed);
  }

// Show an alert dialog asking the user to confirm that the task is done
  void _promptRemoveTodoItem(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
              title: new Text('Remove "${todos[index]}" from the list?'),
              actions: <Widget>[
                new FlatButton(
                    child: new Text('CANCEL'),
                    onPressed: () => Navigator.of(context).pop()
                ),
                new FlatButton(
                    child: new Text('MARK AS DONE'),
                    onPressed: () {
                      _removeTodoItem(index);
                      Navigator.of(context).pop();
                    }
                )
              ]
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the HomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: _buildTodoList(),
      floatingActionButton: new FloatingActionButton(
          onPressed: _pushAddTodoScreen,
          tooltip: 'Add task',
          child: new Icon(Icons.add)
      ),
    );
  } // widget build

  Widget _buildTodoList() {
    return new ListView.builder(
      itemBuilder: (context, index) {
        if(index < todos.length) {
          return _buildTodoItem(index);
        }
      },
    );
  }

  Widget _buildTodoItem(int index) {
    var item = todos[index];
    return new ListTile(
        title: item.completed ? new Text(item.task,
            style: TextStyle (decoration: TextDecoration.lineThrough)): new Text(item.task
        ),
        onTap: () => _updateTodoItem(index),
        trailing: new FlatButton(
            child: new Icon(Icons.cancel),
            onPressed: () {
              _promptRemoveTodoItem(index);
            }
        ),
    );
  }
} // end of class

// The base class for the different types of items the list can contain.
class TodoItem {
  final String task;
  bool completed;

  TodoItem({this.task, this.completed});
}

