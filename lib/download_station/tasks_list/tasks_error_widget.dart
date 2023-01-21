import 'package:flutter/widgets.dart';

class TasksErrorWidget extends StatelessWidget {
  final String _error;
  const TasksErrorWidget(this._error, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: 60,
          height: 60,
          child: Text("Error code: $_error"),
        ),
      ),
    );
  }
}
