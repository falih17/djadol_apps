import 'package:flutter/material.dart';

Future<bool> confirm(
  BuildContext context, {
  Widget? title,
  Widget? content,
  Widget? textOK,
  Widget? textCancel,
  bool canPop = false,
}) async {
  final bool? isConfirm = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) => PopScope(
      canPop: canPop,
      child: AlertDialog(
        title: title,
        content: SingleChildScrollView(
          child: content ?? const Text('Are you sure continue?'),
        ),
        actions: <Widget>[
          TextButton(
            child: textCancel ??
                Text(MaterialLocalizations.of(context).cancelButtonLabel),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child:
                textOK ?? Text(MaterialLocalizations.of(context).okButtonLabel),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    ),
  );
  return isConfirm ?? false;
}

Future<bool> confirmDanger(
  BuildContext context, {
  String? title,
  Widget? content,
  bool canPop = false,
}) async {
  final bool? isConfirm = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) => PopScope(
      canPop: canPop,
      child: AlertDialog(
        title: Text(title ?? 'Warning'),
        content: SingleChildScrollView(
          child: content ?? const Text('Are you sure continue ?'),
        ),
        actions: <Widget>[
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.blueGrey,
              side: const BorderSide(
                color: Colors.blueGrey,
              ),
            ),
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              elevation: 0,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("OK", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ),
  );
  return isConfirm ?? false;
}

popUp(
  BuildContext context,
) {
  showModalBottomSheet(
    context: context,
    builder: (builder) {
      return const Text('Loading ...');
    },
  );
}

class LoadingScreen {
  //private constructor
  LoadingScreen._();
  //the one instance of this singleton
  static final LoadingScreen _instance = LoadingScreen._();
  static LoadingScreen get instance => _instance;
  bool loading = false;

  show(BuildContext context) {
    loading = true;
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(
          child: Card(
              child: Container(
            height: 180,
            width: 180,
            padding: const EdgeInsets.all(20),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [CircularProgressIndicator(), Text('Loading ...')],
            ),
          )),
        );
      },
    );
  }

  hide(BuildContext context) {
    if (loading) Navigator.of(context).pop();
  }
}
