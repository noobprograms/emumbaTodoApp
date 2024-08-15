// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Task {
  final String id;
   String taskName;
  final String currentDate;
  final String currentTime;
   String time;
   String date;
   bool completed;


  Task({
    required this.id,
    required this.taskName,
    required this.currentDate,
    required this.currentTime,
    required this.time,
    required this.date,
    required this.completed
  });

  
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'taskName': taskName,
      'currentDate': currentDate,
      'currentTime': currentTime,
      'time': time,
      'date': date,
      'completed': completed,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['_id'] as String,
      taskName: map['taskName'] as String,
      currentDate: map['currentDate'] as String,
      currentTime: map['currentTime'] as String,
      time: map['time'] as String,
      date: map['date'] as String,
      completed: map['completed'] as bool,
      
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) => Task.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Task(id: $id, taskName: $taskName, currentDate: $currentDate, currentTime: $currentTime, time: $time, date: $date, completed: $completed)';
  }

  



  
}
