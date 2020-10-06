import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/NoteProvider.dart';
import '../widgets/NoteTile.dart';

class NoteListView extends StatefulWidget {
  @override
  _NoteListViewState createState() => _NoteListViewState();
}

class _NoteListViewState extends State<NoteListView> {
  bool _isInit = true;
  bool _isLoading = false;
  @override
  void didChangeDependencies() async {
    if (_isInit) {
      print('Init ran');
      setState(() => _isLoading = true);
      try {
        await Provider.of<Notes>(context).fetchAndSetNotes();
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Error!'),
            titleTextStyle:
                TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            content: Text(
              'Oops !. It looks like something went wrong',
              softWrap: true,
            ),
            contentTextStyle:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            actions: [
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final noteList = Provider.of<Notes>(context);
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : noteList.notes.isEmpty
            ? Center(
                child: Text('No notes added yet'),
              )
            : ListView.builder(
                itemBuilder: (ctx, i) {
                  return NoteTile(
                      id: noteList.notes[i].id, title: noteList.notes[i].title);
                },
                itemCount: noteList.notes.length,
              );
  }
}
