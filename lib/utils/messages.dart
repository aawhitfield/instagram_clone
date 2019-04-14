import 'package:flutter/material.dart';

Widget showErrorMessage(String errorMessage) {
  if (errorMessage.length > 0 && errorMessage != null) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: new Text(
        errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      ),
    );
  } else {
    return new Container(
      height: 0.0,
    );
  }
}

String formatError(String unformattedError) {
  List<String> _errors = unformattedError.split(',');
  int _errorNumber = 1;
  String formattedString = _errors[_errorNumber].trim();

  return formattedString;
}

Future<void> showAlert({BuildContext context, Color titleBgColor, Color titleTextColor, String title, String message}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        titlePadding: EdgeInsets.all(0.0),
        title:  Container(
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.all(0.0),
          child: Text(title,
            style: TextStyle(
              color: titleTextColor,
            ),
          ),
          color: titleBgColor,
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(message),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('OK',
              style: TextStyle(
                color: titleBgColor,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}