import 'package:dsm_sdk/core/models/result_response.dart';
import 'package:dsm_sdk/download_station/models/additional_info.dart';
import 'package:dsm_sdk/download_station/models/download_station_task_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';

import '../../sdk.dart';
import '../create_task/add_download_screen.dart';
import 'task_item_widget.dart';

class TasksScreenWidget extends StatefulWidget {
  const TasksScreenWidget({super.key});

  @override
  State<TasksScreenWidget> createState() => _TasksScreenWidgetState();
}

class _TasksScreenWidgetState extends State<TasksScreenWidget> {
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
        title: const Text("Tasks list"),
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
                                var result = await SDK()
                                    .sdk
                                    .api
                                    .deleteTask(ids: [taskInfoDetailModel.id]);
                                result.ifSuccess((p0) {
                                  _taskList.removeAt(index);
                                  setState(() {});
                                });
                              },
                              color: Colors.red),
                        ],
                        child: TaskItemWidget(model: taskInfoDetailModel),
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
    var result = await _getData();
    result.ifSuccess((p0) => setState(() {
          _taskList = p0.tasks;
        }));
  }

  Future<void> _initData() async {
    var result = await _getData();
    result.ifSuccess((p0) => _taskList = p0.tasks);
  }

  Future<ResultResponse<TasksInfoModel>> _getData() {
    return SDK().sdk.api.getDownloadList(
        additionalInfo: [AdditionalInfo.DETAIL, AdditionalInfo.TRANSFER]);
  }
}
