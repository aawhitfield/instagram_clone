import 'package:flutter/material.dart';
import 'package:firebase_auth_example/data/languages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'forgot_password.dart';
import 'package:firebase_auth_example/utils/messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum FormMode { LOGIN, SIGNUP }

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.auth, this.onSignedIn})
      : super(key: key);

  final String title;
  final FirebaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Instagram',
        ),
      ),
      body: LoginPage(
        auth: widget.auth,
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  final FirebaseAuth auth;

  LoginPage({this.auth});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String dropDownValue = 'English (United States)';
  String _email = '';
  String _password;
  String _errorMessage = '';
  FormMode _formMode = FormMode.LOGIN;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordVerificationController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _success;

  void _changeFormToSignUp() {
    _formKey.currentState.reset();
    _errorMessage = '';
    setState(() {
      _formMode = FormMode.SIGNUP;
    });
  }

  void _changeFormToLogin() {
    _formKey.currentState.reset();
    _errorMessage = '';
    setState(() {
      _formMode = FormMode.LOGIN;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Widget LanguageSelection() {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: DropdownButton<String>(
            value: dropDownValue,
            items:
                languages // from languages.dart -> the list of languages the app supports
                    .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 11.0,
                  ),
                ),
              );
            }).toList(),
            onChanged: (String newValue) {
              setState(() {
                dropDownValue = newValue;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget AppTitle() {
    return Text(
      'Instagram',
      style: TextStyle(
        fontFamily: 'Amarillo',
        fontSize: 24,
      ),
    );
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  // Example code of how to sign in with email and password.
  void _signInWithEmailAndPassword() async {
    try {
      final FirebaseUser user = await widget.auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (user != null) {
        setState(() {
          _success = true;
          _email = user.email;
        });
      } else {
        _success = false;
      }
    } on Exception catch (e) {
      List<String> _errors = e.toString().split(',');
      int _errorNumber = 1;
      setState(() {
        _errorMessage = _errors[_errorNumber].trim();
      });
    }
  }

  void _register() async {
    try {
      final FirebaseUser user =
          await widget.auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (user != null) {
        setState(() {
          _success = true;
          _email = user.email;
          user.sendEmailVerification();
          Firestore.instance.runTransaction((Transaction transaction) async {

            DocumentReference _newUser = Firestore.instance.collection('users').document(user.uid);

            await _newUser.setData({"email": user.email, "id": user.uid});
            await _newUser.collection('cards').add({"url" : "https://images.unsplash.com/photo-1555411093-7440ae076e89?ixlib=rb-1.2.1&auto=format&fit=crop&w=1650&q=80"});

          });
        });
      } else {
        _success = false;
      }
    } on Exception catch (e) {

      setState(() {
        _errorMessage = formatError(e.toString());
      });
    }
  }

//////////////////////////////////////////////////////////////////////////////// SIGN IN FORM
  Widget SignInForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            // USERNAME
            controller: _emailController,
            decoration: InputDecoration(
              hintText: 'E-mail address',
              fillColor: Colors.grey[200],
              filled: true,
              border: OutlineInputBorder(),
            ),
            maxLines: 1,
            keyboardType: TextInputType.emailAddress,
            validator: (value) =>
                value.isEmpty ? 'Please enter a username' : null,
            onSaved: (value) => _email = value,
          ),
          SizedBox(
            height: 16.0,
          ),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            maxLines: 1,
            decoration: InputDecoration(
              // PASSWORD
              hintText: 'Password',
              fillColor: Colors.grey[200],
              filled: true,
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                value.isEmpty ? 'Please enter a password' : null,
            onSaved: (value) => _password = value,
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: _formMode == FormMode.SIGNUP
                ? TextFormField(
                    obscureText: true,
                    maxLines: 1,
                    decoration: InputDecoration(
                      // PASSWORD VERIFICATION
                      hintText: 'Verify Password',
                      fillColor: Colors.grey[200],
                      filled: true,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value != _passwordController.text
                        ? 'Passwords do not match.'
                        : null,
                    onSaved: (value) => _password = value,
                  )
                : null,
          ),
          _showErrorMessage(),
          SizedBox(
            height: 16.0,
          ),
          RaisedButton(
            // BUTTON
            color: Colors.blue,
            child: _formMode == FormMode.LOGIN
                ? Text(
                    'Log In',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
                : Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                _formMode == FormMode.LOGIN
                    ? _signInWithEmailAndPassword()
                    : _register();
              }
            },
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _success == null
                  ? ''
                  : (_success
                      ? 'Successfully signed in ' + _email
                      : 'Sign in failed'),
              style: TextStyle(color: Colors.red),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Forgot your login details?',
                style: TextStyle(
                  fontSize: 11.0,
                ),
              ),
              SizedBox(
                width: 8.0,
              ),
              FlatButton(
                child: Text(
                  'Get help signing in.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11.0,
                  ),
                ),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ForgotPassword(auth: widget.auth,))),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _showBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 32.0,
        right: 32.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          LanguageSelection(),
          SizedBox(
            height: 100.0,
          ),
          AppTitle(),
          SizedBox(
            height: 40.0,
          ),
          SignInForm(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordVerificationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _showBody(),
          //_showCircularProgress(),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Divider(
              color: Colors.grey[700],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    bottom: 8.0,
                  ),
                  child: _formMode == FormMode.LOGIN
                      ? Text(
                          'Don\'t  have an account?',
                          style: TextStyle(
                            fontSize: 10.0,
                          ),
                        )
                      : Text(
                          'Have an account?',
                          style: TextStyle(
                            fontSize: 10.0,
                          ),
                        ),
                ),
                FlatButton(
                  child: _formMode == FormMode.LOGIN
                      ? Text(
                          'Sign Up',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10.0,
                          ),
                        )
                      : Text(
                          'Sign In',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10.0,
                          ),
                        ),
                  onPressed: _formMode == FormMode.LOGIN
                      ? _changeFormToSignUp
                      : _changeFormToLogin,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
