class User {
  final String note, title, theme, time;

  const User({
    required this.note,
    required this.title,
    required this.theme,
    required this.time,
  });

  factory User.fromMap(Map<dynamic, dynamic> map) {
    return User(
      note: map['note'] ?? '',
      title: map['title'] ?? '',
      theme: map['theme'] ?? '',
      time: map['time'] ?? '',
    );
  }
}
