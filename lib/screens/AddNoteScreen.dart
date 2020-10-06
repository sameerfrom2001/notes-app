import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/NoteProvider.dart';

class AddNoteScreen extends StatefulWidget {
  static const routeName = '/addnote-screen';

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _descriptionNode = FocusNode();
  final _form = GlobalKey<FormState>();

  var editedNote = NoteItem(description: '', title: '', id: null);

  bool _isLoading = false;

  @override
  void dispose() {
    _descriptionNode.dispose();
    super.dispose();
  }

  var _initValue = {
    'title': '',
    'description': '',
  };
  var isInit = true;
  @override
  void didChangeDependencies() {
    if (isInit) {
      final noteId = ModalRoute.of(context).settings.arguments as String;
      if (noteId != null) {
        final noteToShow =
            Provider.of<Notes>(context, listen: false).findById(noteId);
        editedNote = noteToShow;
        _initValue = {
          'title': editedNote.title,
          'description': editedNote.description,
        };
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  Future<void> saveForm() async {
    setState(() {
      _isLoading = true;
    });
    final isValid = _form.currentState.validate();
    if (isValid) {
      _form.currentState.save();
    } else {
      setState(() => _isLoading = false);
      return;
    }
    if (editedNote.id != null) {
      try {
        await Provider.of<Notes>(context, listen: false)
            .updateProduct(editedNote.id, editedNote);
        setState(() {
          _isLoading = false;
        });
      } catch (eror) {
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
        Navigator.of(context).pop();
      }
    } else {
      try {
        await Provider.of<Notes>(context, listen: false).addNote(editedNote);
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
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Notes'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _form,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: _initValue['title'],
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Title',
                        ),
                        textInputAction: TextInputAction.next,
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_descriptionNode);
                        },
                        onSaved: (newValue) {
                          editedNote.title = newValue;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          initialValue: _initValue['description'],
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a description';
                            }
                            if (value.length < 8) {
                              return 'Description must be atleast 8 characters long';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Description',
                            labelStyle: TextStyle(
                                fontSize: 35, fontWeight: FontWeight.bold),
                            alignLabelWithHint: true,
                          ),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.multiline,
                          maxLines: 7,
                          focusNode: _descriptionNode,
                          style: TextStyle(
                            fontSize: 25,
                          ),
                          onSaved: (newValue) {
                            editedNote.description = newValue;
                          },
                          onFieldSubmitted: (_) {
                            saveForm();
                          }),
                    ),
                    const SizedBox(height: 30),
                    MaterialButton(
                      minWidth: 200,
                      height: 60,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      splashColor: Colors.amberAccent,
                      child: Text(
                        'Save',
                        style: TextStyle(fontSize: 20),
                      ),
                      color: Theme.of(context).accentColor,
                      onPressed: saveForm,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
