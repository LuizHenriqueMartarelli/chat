import 'dart:io';

import 'package:chat/models/auth_data.dart';
import 'package:chat/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(AuthData auth) onSubmit;

  AuthForm(this.onSubmit);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final AuthData _authData = AuthData();

  _submit() {
    bool isValid = _formKey.currentState?.validate() ?? false;
    FocusScope.of(context).unfocus();

    if (_authData.image == null && _authData.isSignup) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Precisamos da sua foto'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }

    if (isValid) {
      widget.onSubmit(_authData);
    }
  }

  void _handlePickerImage(File image) {
    _authData.image = image;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                if (_authData.isSignup) UserImagePicker(_handlePickerImage),
                if (_authData.isSignup)
                  TextFormField(
                    autocorrect: true,
                    textCapitalization: TextCapitalization.words,
                    enableSuggestions: false,
                    key: ValueKey('name'),
                    initialValue: _authData.name,
                    decoration: InputDecoration(labelText: 'Nome'),
                    onChanged: (value) => _authData.name = value,
                    validator: (value) {
                      if (value == null || value.trim().length < 4)
                        return 'Informe um nome com no minimo 4 caracteres!';

                      return null;
                    },
                  ),
                TextFormField(
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  enableSuggestions: false,
                  key: ValueKey('email'),
                  decoration: InputDecoration(labelText: 'E-mail'),
                  onChanged: (value) => _authData.email = value,
                  validator: (value) {
                    if (value == null || !value.contains('@'))
                      return 'Informe um e-mail válido!';

                    return null;
                  },
                ),
                TextFormField(
                  key: ValueKey('password'),
                  decoration: InputDecoration(labelText: 'Senha'),
                  obscureText: true,
                  onChanged: (value) => _authData.password = value,
                  validator: (value) {
                    if (value == null || value.trim().length < 7)
                      return 'Informe uma senha com no minimo 7 caracteres!';

                    return null;
                  },
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(_authData.isLogin ? 'Entrar' : 'Cadastrar-se'),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      primary: Theme.of(context).primaryColor),
                  onPressed: () {
                    setState(() {
                      _authData.toogleMode();
                    });
                  },
                  child: Text(_authData.isLogin
                      ? 'Criar uma nova conta?'
                      : 'Já possuo uma conta!'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
