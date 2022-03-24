import 'package:flutter/material.dart';

class LoadingDialogWidget extends StatelessWidget {
  final message;

  LoadingDialogWidget(this.message);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        key: key,
        backgroundColor: Colors.black54,
        children: <Widget>[
          Center(
            child: Column(children: [
              CircularProgressIndicator(),
              SizedBox(
                height: 10,
              ),
              Text(
                this.message,
                style: TextStyle(color: Colors.blueAccent),
              )
            ]),
          )
        ]);
  }
}
