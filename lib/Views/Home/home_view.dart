import 'package:flutter/material.dart';
import 'package:trzecia_proba/Views/Login/login_view.dart';
import '../../models/note.dart';
import '../../services/database_helper.dart';
import 'add_note_view.dart';

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
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Wyloguj',
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginView()));
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
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await DatabaseHelper.instance.deleteNote(note.id!);
                    setState(() {
                      _fetchNotes();
                    });
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
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
