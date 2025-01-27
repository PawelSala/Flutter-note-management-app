import 'package:flutter/material.dart';
import 'package:trzecia_proba/utils/my_colors.dart';
import '../../models/note.dart';
import '../../services/database_helper.dart';

class AddNoteView extends StatelessWidget {
  final String userEmail;
  final Note? note;

  AddNoteView({super.key, required this.userEmail, this.note});

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (note != null) {
      titleController.text = note!.title;
      contentController.text = note!.content;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(note == null ? "Dodaj notatkę" : "Edytuj notatkę"),
        backgroundColor: MyColors.purpleColor,
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
                if (titleController.text.trim().isEmpty ||
                    contentController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Tytuł i treść nie mogą być puste!"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                if (note == null) {
                  final newNote = Note(
                    title: titleController.text.trim(),
                    content: contentController.text.trim(),
                    userEmail: userEmail,
                  );
                  await DatabaseHelper.instance.addNote(newNote);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Notatka dodana!")),
                  );
                } else {
                  final updatedNote = Note(
                    id: note!.id,
                    title: titleController.text.trim(),
                    content: contentController.text.trim(),
                    userEmail: userEmail,
                  );
                  await DatabaseHelper.instance.updateNote(updatedNote);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Notatka zaktualizowana!")),
                  );
                }

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: MyColors.purpleColor),
              child: Text(note == null ? "Dodaj" : "Zaktualizuj",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
