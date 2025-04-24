// import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'map.dart';
// import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: TaskPage() 
    );
  }
}

class TaskPage extends StatefulWidget {

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {

  List <String> tasks = ['Walk Ranger', 'DO the dishes', 'singing lessons'];

  // List <String> tasks = ["Drink water", "Stretch for 5 mins", "Make your bed", "Read 1 page of a book", "Take a deep breath", "Clean your desk", "Reply to 1 message", "Check calendar", "Write down 1 goal", "Do 10 push-ups", "Organize 1 folder", "Charge your phone", "Update your to-do list", "Back up your files", "Take a 5 min walk", "Clean out 1 email", "Water a plant", "Plan tomorrow", "Do 1 chore", "Clear notifications"];
  List <String> fintasks = [];

  List <String> locations = ["New York", "Tokyo", "Paris", "London", "Berlin", "Sydney", "Toronto", "Beijing", "Moscow", "Rome", "Cairo", "Mumbai", "Seoul", "Bangkok", "Dubai"];

  void addTask(String task) {
    setState( () {
      tasks.add(task);
    });
  }

  void finishTask(String task) {
    setState( () {
      tasks.remove(task);
      fintasks.add(task);

      if (fintasks.length > 8){
        fintasks.removeAt(0);
      }
    });
  }

  @override

  Widget build(BuildContext context) {

    return Scaffold(

        body: SingleChildScrollView(
          child: Column(
          
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text('Test App Interface'),
            ),
            
            TaskList(
              tasks: tasks,
              fintasks: fintasks,
              addTask: addTask,
              finishTask: finishTask,
              ),
            
            TypeTask(
              tasks: tasks,
              addTask: addTask
            ),

            PlacesVisited(
              locations: locations,
            )
            
            ],),
        )
      );

  }


}



class TaskList extends StatefulWidget {

  final List<String> tasks;
  final List<String> fintasks;
  final Function(String) addTask;
  final Function(String) finishTask;

  const TaskList({required this.tasks, required this.addTask, required this.finishTask, required this.fintasks});

  @override

  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {

  @override

  Widget build(BuildContext context){
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Text('Your Tasks', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
            ),

          SizedBox(
            height: 80,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: 
                widget.tasks.map<Widget>((task) => Container(
                    
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(12),),
                    child: ElevatedButton(
                      
                      onPressed: () => widget.finishTask(task), 
                      child: Text(task)
                      
                      ))).toList()),
              ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Text('Finished Tasks', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),

          // SizedBox(height: 60), // Box to keep the finished tasks in place

          SizedBox(
            height: 80,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: widget.fintasks.map<Widget>((task) => Container(
                    
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 5, 54, 30),
                    borderRadius: BorderRadius.circular(12),),
                    child: ElevatedButton(
                      
                      onPressed: null, 
                      child: Text(task, style: TextStyle(color: Colors.white),)
                      
                      ))).toList()),
              ),
          ),

          SizedBox(height: 60)

          ]);
  }
}


class TypeTask extends StatefulWidget {

  final List<String> tasks;
  final Function(String) addTask;

  const TypeTask({required this.tasks, required this.addTask});

  @override

  _TypeTaskState createState() => _TypeTaskState();

  
}

class _TypeTaskState extends State<TypeTask> {

  final TextEditingController _controller = TextEditingController(); // Controller for the TextField

  @override

  Widget build(BuildContext context){

    return Center(
          child: Column(children: [

            SizedBox(
              height: 50,
            ),

            Padding(
                padding: const EdgeInsets.all(2.0), // Add some padding around the TextField
                child: TextField(
                  controller: _controller, // Attach the controller
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter a task', // Label for the TextField
                  ),
                ),
              ),

            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty){
                  widget.addTask(_controller.text);
                  _controller.clear();
                }
              },
              child: Text('Press to add Task')),

            SizedBox(height: 50),

            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreen()));
              },
              child: Text('Map'),
            )
 
          ],),
        );

  }
}

class PlacesVisited extends StatefulWidget {

  final List<String> locations;
  
  const PlacesVisited({required this.locations});

  @override

  _PlacesVisitedState createState() => _PlacesVisitedState();

}

class _PlacesVisitedState extends State<PlacesVisited> {

  @override

  Widget build(BuildContext context) {
    return Column(
      children: [

        Text('Places Visited'),

        Center(
          child: SizedBox(
            height: 500,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: widget.locations.map<Widget>((loc) => Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 203, 5, 5),
                  borderRadius: BorderRadius.circular(12),),
                  child: Text(loc),
                  )).toList(),
              )
            )
          ),
        )

      ],
    );
  }
}













