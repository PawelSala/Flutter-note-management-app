class Note {
  final int? id;
  final String title;
  final String content;
  final String userEmail; // Powiązanie z użytkownikiem

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.userEmail,
  });

  // Konwersja na mapę do zapisu w SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'userEmail': userEmail,
    };
  }

  // Tworzenie obiektu z mapy (odczyt z SQLite)
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      userEmail: map['userEmail'],
    );
  }
}
