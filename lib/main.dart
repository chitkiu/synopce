import 'package:dsm_sdk/request/models/download_station/additional_info.dart';
import 'package:dsm_sdk/request/models/download_station/download_station_task_info_model.dart';
import 'package:dsm_sdk/request/models/response_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';

import 'constants.dart' as Constants;
import 'download_station/add_download_screen.dart';
import 'download_station/task_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _incrementCounter() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddDownloadTaskWidget()),
    );
  }

  late List<TaskInfoDetailModel> _taskList = List.empty();
  late Future<void> _taskListData;

  @override
  void initState() {
    super.initState();
    _taskListData = _initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: FutureBuilder<void>(
          future: _taskListData,
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            List<Widget> children;
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                children = [
                  const SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  )
                ];
                break;
              case ConnectionState.done:
                children = [
                  Expanded(
                      child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _taskList.length,
                    itemBuilder: (BuildContext context, int index) {
                      var taskInfoDetailModel = _taskList[index];
                      return SwipeActionCell(
                        key: ObjectKey(taskInfoDetailModel),
                        trailingActions: [
                          SwipeAction(
                              title: "delete",
                              onTap: (CompletionHandler handler) async {
                                var result = await Constants.sdk.api
                                    .deleteTask(ids: [taskInfoDetailModel.id]);
                                if (result is ResponseDownloadStationTasksDeleteSuccess) {
                                  _taskList.removeAt(index);
                                  setState(() {});
                                }
                              },
                              color: Colors.red),
                        ],
                        child: TaskView(model: taskInfoDetailModel),
                      );
                    },
                  ))
                ];
                break;
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _pullRefresh() async {
    List<TaskInfoDetailModel> models = await _getData();
    setState(() {
      _taskList = models;
    });
  }

  Future<void> _initData() async {
    _taskList = await _getData();
  }

  Future<List<TaskInfoDetailModel>> _getData() {
    return Constants.sdk.api.auth().then((value) {
      return Constants.sdk.api.getDownloadList(
          additionalInfo: [AdditionalInfo.DETAIL, AdditionalInfo.TRANSFER]);
    }).then((responseStatus) {
      if (responseStatus is ResponseDownloadStationTasksInfoSuccess) {
        return responseStatus.model.tasks;
      } else if (responseStatus is ResponseError) {
        throw Exception("ResponseError ${responseStatus.type}");
      }
      return List.empty();
    });
  }
}
