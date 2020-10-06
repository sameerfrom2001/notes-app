import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/NoteProvider.dart';

class ViewNoteScreen extends StatelessWidget {
  static const routeName = '/viewnote-screen';
  @override
  Widget build(BuildContext context) {
    final noteId = ModalRoute.of(context).settings.arguments as String;
    final noteToShow = Provider.of<Notes>(context).findById(noteId);
    return Scaffold(
      appBar: AppBar(
        title: Text('View Note'),
        centerTitle: true,
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 15, 0, 5),
            child: Text(
              noteToShow.title,
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(
            color: Theme.of(context).primaryColor,
            thickness: 5,
            endIndent: 10,
            indent: 10,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 15, 10, 5),
            child: Text(
              noteToShow.description,
              style: TextStyle(fontSize: 28),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
