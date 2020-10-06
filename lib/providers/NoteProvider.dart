import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/HttpException.dart';

class NoteItem {
  String title;
  String description;
  final String id;

  NoteItem({
    @required this.description,
    @required this.title,
    @required this.id,
  });
}

class Notes with ChangeNotifier {
  List<NoteItem> _notes = [];
  final String authToken;
  final String userId;
  Notes(this.authToken, this._notes, this.userId);

  NoteItem findById(String id) {
    return _notes.firstWhere((note) => note.id == id);
  }

  List<NoteItem> get notes {
    return [..._notes];
  }

  Future<void> fetchAndSetNotes() async {
    final url = 'https://www.dummyurl.com';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        _notes = [];
        notifyListeners();
      } else {
        final List<NoteItem> loadedNotes = [];
        extractedData.forEach((noteId, noteData) {
          loadedNotes.add(NoteItem(
              description: noteData['description'],
              title: noteData['title'],
              id: noteId));
        });
        _notes = loadedNotes;
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, NoteItem note) async {
    final url = 'https://www.dummyurl.com';
    try {
      final response = await http.patch(url,
          body: json.encode({
            'description': note.description,
            'title': note.title,
          }));
      if (response.statusCode < 400) {
        final index = _notes.indexWhere((e) => e.id == id);
        _notes[index] = note;
        notifyListeners();
      } else {
        throw HttpException('Error');
      }
    } catch (eror) {
      throw eror;
    }
  }

  Future<void> addNote(NoteItem note) async {
    final url = 'https://www.dummyurl.com';

    try {
      final response = await http.post(url,
          body: json.encode({
            'title': note.title,
            'description': note.description,
            'creatorId': userId,
          }));
      final newNote = NoteItem(
        title: note.title,
        description: note.description,
        id: json.decode(response.body)['name'],
      );
      _notes.add(newNote);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      final url = 'https://www.dummyurl.com';
      final response = await http.delete(url);
      if (response.statusCode < 400) {
        _notes.removeWhere((element) => element.id == id);
        notifyListeners();
      } else {
        print(response.statusCode);
        throw HttpException('Could not delete item');
      }
    } catch (error) {
      throw error;
    }
  }
}
