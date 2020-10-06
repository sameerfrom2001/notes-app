import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/NoteListView.dart';
import 'AddNoteScreen.dart';
import '../providers/NoteProvider.dart';
import '../providers/Auth.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = 'home-screen';

  Future<void> _refreshNotes(BuildContext context) async {
    await Provider.of<Notes>(context, listen: false).fetchAndSetNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              size: 32,
            ),
            onPressed: () {
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: RefreshIndicator(
          onRefresh: () => _refreshNotes(context), child: NoteListView()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AddNoteScreen.routeName);
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
