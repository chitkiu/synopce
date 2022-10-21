import 'package:dsm_app/download_station/tasks_list/data/models/data_result.dart';
import 'package:dsm_app/download_station/tasks_list/task_item_widget.dart';
import 'package:dsm_sdk/download_station/models/download_station_task_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../create_task/add_download_screen.dart';
import '../task_info/task_info_screen_widget.dart';
import 'data/tasks_info_provider.dart';
import 'data/tasks_repository.dart';
import 'domain/models/tasks_events.dart';
import 'domain/tasks_bloc.dart';

class TasksScreenWidget extends StatelessWidget {
  const TasksScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TasksBLoC>(
      create: (context) => TasksBLoC(TasksRepository(TasksInfoProvider()))..add(LoadEvents()),
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Tasks list"),
          ),
          body: BlocBuilder<TasksBLoC, Data>(
            builder: (context, state) {
              if (state is Success) {
                var list = state.models.toList();
                return ScreenTypeLayout(
                  mobile: _mobileWidget(list),
                  tablet: _desktopWidget(list, state.selectedTaskId),
                  desktop: _desktopWidget(list, state.selectedTaskId),
                );
              }
              //TODO Add other state
              return const Center(
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ),
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddDownloadTaskWidget()),
              );
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          )),
    );
  }

  Widget _mobileWidget(List<TaskInfoDetailModel> items) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              var taskInfoDetailModel = items[index];
              return SwipeActionCell(
                key: ObjectKey(taskInfoDetailModel),
                trailingActions: [
                  SwipeAction(
                      title: "delete",
                      onTap: (CompletionHandler handler) async {
                        BlocProvider.of<TasksBLoC>(context)
                            .add(DeleteEvent(taskInfoDetailModel.id));
                      },
                      color: Colors.red),
                ],
                child: TaskItemWidget(taskInfoDetailModel, (model) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TaskInfoScreenWidget(model)),
                  );
                }),
              );
            },
          ))
        ],
      ),
    );
  }

  Widget _desktopWidget(List<TaskInfoDetailModel> items, String? selectedId) {
    TaskInfoDetailModel? selectedModel;
    for (var element in items) {
      if (element.id == selectedId) {
        selectedModel = element;
        break;
      }
    }
    return Row(
      children: [
        SizedBox(
          width: 300,
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              var taskInfoDetailModel = items[index];
              return SwipeActionCell(
                key: ObjectKey(taskInfoDetailModel),
                trailingActions: [
                  SwipeAction(
                      title: "delete",
                      onTap: (CompletionHandler handler) async {
                        BlocProvider.of<TasksBLoC>(context)
                            .add(DeleteEvent(taskInfoDetailModel.id));
                      },
                      color: Colors.red),
                ],
                child: TaskItemWidget(taskInfoDetailModel, (model) {
                  BlocProvider.of<TasksBLoC>(context)
                      .add(SelectEvent(taskInfoDetailModel.id));
                }),
              );
            },
          ),
        ),
        Container(width: 0.5, color: Colors.black),
        Expanded(
            child: (selectedModel != null
                ? TaskInfoScreenWidget(selectedModel)
                : const Align(
                    alignment: AlignmentDirectional.center,
                    child: Text("Select item"),
                  ))),
      ],
    );
  }
}
