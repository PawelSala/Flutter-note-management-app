import 'package:flutter/material.dart';
import '../../models/note.dart';
import '../../services/database_helper.dart';

class AddNoteView extends StatelessWidget {
  final String userEmail;

  AddNoteView({super.key, required this.userEmail});

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dodaj notatkę"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Tytuł"),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: "Treść"),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final note = Note(
                  title: titleController.text,
                  content: contentController.text,
                  userEmail: userEmail,
                );
                await DatabaseHelper.instance.addNote(note);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Notatka dodana!")),
                );
                Navigator.pop(context); // Powrót do poprzedniego widoku
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              child: const Text("Dodaj"),
            ),
          ],
        ),
      ),
    );
  }
}
