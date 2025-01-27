import 'package:flutter/material.dart';
import 'package:trzecia_proba/Views/Login/login_view.dart';
import 'package:trzecia_proba/utils/my_colors.dart';
import '../../models/note.dart';
import '../../services/database_helper.dart';
import 'add_note_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  final String userEmail;

  const HomeView({super.key, required this.userEmail});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Future<List<Note>> _notes;

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  void _fetchNotes() {
    _notes = DatabaseHelper.instance.getUserNotes(widget.userEmail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Twoje notatki"),
        backgroundColor: MyColors.purpleColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout,
            color: Colors.red,
            ),
            tooltip: 'Wyloguj',
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('isLoggedIn');
              await prefs.remove('userEmail');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginView()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Note>>(
        future: _notes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Błąd: ${snapshot.error}"));
          }
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text("Brak notatek"));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final note = snapshot.data![index];
              return ListTile(
                title: Text(note.title),
                subtitle: Text(note.content),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddNoteView(
                              userEmail: widget.userEmail,
                              note: note,
                            ),
                          ),
                        );
                        setState(() {
                          _fetchNotes();
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await DatabaseHelper.instance.deleteNote(note.id!);
                        setState(() {
                          _fetchNotes();
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.purpleColor,
        foregroundColor: Colors.red,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNoteView(userEmail: widget.userEmail),
            ),
          ).then((_) => setState(() {
            _fetchNotes();
          }));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
