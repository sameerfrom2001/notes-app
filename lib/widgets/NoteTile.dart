import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/AddNoteScreen.dart';
import '../screens/ViewNoteScreen.dart';
import '../providers/NoteProvider.dart';

class NoteTile extends StatelessWidget {
  final String id;
  final String title;
  NoteTile({this.title, this.id});

  @override
  Widget build(BuildContext context) {
    //final note = Provider.of<Notes>(context);
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      color: Colors.white,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 20, 0, 20),
        trailing: Container(
          width: 120,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                color: Colors.black,
                iconSize: 35,
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(AddNoteScreen.routeName, arguments: id);
                },
              ),
              DeleteButton(id: id),
            ],
          ),
        ),
        onTap: () {
          Navigator.of(context)
              .pushNamed(ViewNoteScreen.routeName, arguments: id);
        },
      ),
    );
  }
}

class DeleteButton extends StatefulWidget {
  final String id;
  DeleteButton({this.id});

  @override
  _DeleteButtonState createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<DeleteButton> {
  bool _isLoading = false;

  Future<void> deleteFunc() async {
    try {
      setState(() => _isLoading = true);
      await Provider.of<Notes>(context, listen: false).deleteNote(widget.id);
      setState(() => _isLoading = false);
    } catch (error) {
      print(error.toString());
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          'Deletion Failed',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : IconButton(
            icon: Icon(Icons.delete),
            color: Colors.red,
            iconSize: 35,
            onPressed: deleteFunc,
          );
  }
}
