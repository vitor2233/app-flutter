import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_crud/routes/app_routes.dart';
import 'package:flutter_crud/models/user.dart';
import 'package:flutter_crud/provider/users.dart';
import 'package:provider/provider.dart';

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _form = GlobalKey<FormState>();

  final Map<String, Object> _formData = {};

  void _loadFormData(User user) {
    if (user != null) {
      _formData['id'] = user.id;
      _formData['name'] = user.name;
      _formData['email'] = user.email;
      _formData['avatarUrl'] = user.avatarUrl;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final User user = ModalRoute.of(context).settings.arguments;
    _loadFormData(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de usuário'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              bool isValid = _form.currentState.validate();
              if (isValid) {
                _form.currentState.save();
                Provider.of<UsersProvider>(context, listen: false).put(User(
                  id: _formData['id'],
                  name: _formData['name'],
                  email: _formData['email'],
                  avatarUrl: _formData['avatarUrl'],
                ));
                Navigator.of(context).pop();
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.TAKE_PICTURE,
                );
              },
            ),
            Form(
              key: _form,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    initialValue: _formData['name'],
                    decoration: InputDecoration(
                      labelText: 'Nome',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nome é obrigatório';
                      }
                      if (value.trim().length < 3) {
                        return 'Nome precisa de ter mais que 2 caracteres';
                      }

                      return null;
                    },
                    onSaved: (value) => _formData['name'] = value,
                  ),
                  TextFormField(
                    initialValue: _formData['email'],
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                    ),
                    onSaved: (value) => _formData['email'] = value,
                  ),
                  TextFormField(
                    initialValue: _formData['avatarUrl'],
                    decoration: InputDecoration(
                      labelText: 'Avatar url',
                    ),
                    onSaved: (value) => _formData['avatarUrl'] = value,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.file(File(imagePath)),
    );
  }
}
