class TaskMap {
  final String task, theme, time, schedule;
  final bool pending;

  const TaskMap({
    required this.task,
    required this.theme,
    required this.time,
    required this.pending,
    required this.schedule,
  });

  factory TaskMap.fromMap(Map<dynamic, dynamic> map) {
    return TaskMap(
      pending: map['pending'] == "false" ? false : true,
      task: map['task'] ?? '',
      theme: map['theme'] ?? '',
      time: map['time'] ?? '',
      schedule: map['schedule'] ?? '',
    );
  }
}
