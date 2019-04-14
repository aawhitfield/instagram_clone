import 'package:flutter/material.dart';
import 'package:firebase_auth_example/utils/messages.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPassword extends StatefulWidget {
  static final GlobalKey<FormState> _resetFormKey = GlobalKey<FormState>();

  final FirebaseAuth auth;

  ForgotPassword({this.auth});
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _emailController = TextEditingController();

  String _email;
  String _errorMessage = '';

  Key _k1 = new GlobalKey();

  Widget _showHeader(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: 64.0),
        child: Text(
          'Find Your Account',
          style: Theme.of(context).textTheme.headline,
        ),
      ),
    );
  }

  Widget _showPrompt() {
    return Container(
      padding: EdgeInsets.only(top: 32.0),
      child: Text(
        'Enter your Instagram username or the email or phone '
            'number linked to your account.',
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _requestUserName() {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: TextFormField(
        // USERNAME
        key: _k1,
        controller: _emailController,
        decoration: InputDecoration(
          hintText: 'E-mail address',
          fillColor: Colors.grey[200],
          filled: true,
          border: OutlineInputBorder(),
        ),
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        validator: (value) => value.isEmpty ? 'Please enter a username' : null,
        onSaved: (value) => _email = value,
      ),
    );
  }

  void _sendPasswordResetEmail(String email) async {
    try {
      setState(() {
        _errorMessage = '';
      });
      await widget.auth.sendPasswordResetEmail(email: email);
      showAlert(
          context: context,
          titleBgColor: Colors.green,
          titleTextColor: Colors.white,
          title: 'Password Reset',
          message: 'Your password reset link has been sent to your email address. If you cannot find '
              'the message in your inbox, check your junk or spam filters'
      );
    } on Exception catch (e) {
      setState(() {
        _errorMessage = formatError(e.toString());
      });
    }
  }

  Widget _showNextButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: RaisedButton(
        color: Colors.blue,
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
          child: Text(
            'Next',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        onPressed: () async {
          if (ForgotPassword._resetFormKey.currentState.validate()) {
            _sendPasswordResetEmail(_emailController.text);

          }
        },
      ),
    );
  }

  @override
  void initState(){

    super.initState();
    _errorMessage = '';
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          'Login Help',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.grey[100],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 32.0, right: 32.0),
        child: Form(
          key: ForgotPassword._resetFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _showHeader(context),
              _showPrompt(),
              _requestUserName(),
              showErrorMessage(_errorMessage),
              _showNextButton(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'For more help, visit the ',
              style: TextStyle(
                fontSize: 10.0,
              ),
            ),
            Text(
              'Instagram Help Center.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
