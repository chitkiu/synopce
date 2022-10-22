import 'dart:async';

import 'package:collection/collection.dart'; // You have to add this manually, for some reason it cannot be added automatically
import 'package:dsm_app/download_station/tasks_list/task_item_widget.dart';
import 'package:dsm_sdk/download_station/tasks/info/ds_task_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../create_task/add_download_screen.dart';
import '../task_info/task_info_screen_widget.dart';
import 'bloc/open_task_info/task_info_bloc.dart';
import 'bloc/open_task_info/task_info_event.dart';
import 'bloc/open_task_info/task_info_state.dart';
import 'bloc/tasks/tasks_bloc.dart';
import 'bloc/tasks/tasks_events.dart';
import 'bloc/tasks/tasks_state.dart';
import 'data/tasks_info_provider.dart';
import 'data/tasks_repository.dart';

class TasksScreenWidget extends StatelessWidget {
  const TasksScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bloc = TasksBloc(TasksRepository(TasksInfoProvider()))..add(LoadTasksEvent());

    Timer.periodic(const Duration(seconds: 3), (timer) {
      bloc.add(LoadTasksEvent());
    });
    return MultiBlocProvider(
      providers: [
        BlocProvider<TasksBloc>(
          create: (context) => bloc,
        ),
        BlocProvider(create: (context) => TaskInfoBloc())
      ],
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Tasks list"),
          ),
          body: BlocBuilder<TasksBloc, TasksState>(
            bloc: bloc,
            builder: (context, state) {
              switch (state.runtimeType) {
                case SuccessTasksState:
                  var list = (state as SuccessTasksState).models.toList();
                  return ScreenTypeLayout(
                    mobile: _mobileWidget(list),
                    tablet: _desktopWidget(list),
                    desktop: _desktopWidget(list),
                  );
                case ErrorTasksState:
                  var errorText = (state as ErrorTasksState).errorType.name;
                  return Center(
                    child: Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: Text("Error code: $errorText"),
                      ),
                    ),
                  );
                case LoadingTasksState:
                default:
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
              }
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
            tooltip: 'Add download',
            child: const Icon(Icons.add),
          )),
    );
  }

  Widget _mobileWidget(List<TaskInfoDetailModel> items) {
    return BlocListener<TaskInfoBloc, TaskInfoState>(
      listener: (context, state) {
        if (state is ShowTaskInfoState) {
          var task =
              items.firstWhereOrNull((element) => element.id == state.taskId);
          if (task != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TaskInfoScreenWidget(task)),
            );
          }
        }
      },
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: _getItemsList(items)),
          ],
        ),
      ),
    );
  }

  Widget _desktopWidget(List<TaskInfoDetailModel> items) {
    return Row(
      children: [
        SizedBox(
          width: 300,
          child: _getItemsList(items),
        ),
        Container(width: 0.5, color: Colors.black),
        BlocBuilder<TaskInfoBloc, TaskInfoState>(builder: (context, state) {
          var task;
          if (state is ShowTaskInfoState) {
            task =
                items.firstWhereOrNull((element) => element.id == state.taskId);
          }
          return Expanded(
              child: (task != null
                  ? TaskInfoScreenWidget(task)
                  : const Align(
                      alignment: AlignmentDirectional.center,
                      child: Text("Select item"),
                    )));
        }),
      ],
    );
  }

  Widget _getItemsList(List<TaskInfoDetailModel> items) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        var taskInfoDetailModel = items[index];
        return SwipeActionCell(
          key: ObjectKey(taskInfoDetailModel),
          trailingActions: [
            SwipeAction(
                title: "delete",
                onTap: (CompletionHandler handler) {
                  BlocProvider.of<TasksBloc>(context)
                      .add(DeleteTasksEvent(taskInfoDetailModel.id));
                },
                color: Colors.red),
          ],
          child: TaskItemWidget(taskInfoDetailModel, (model) {
            BlocProvider.of<TaskInfoBloc>(context)
                .add(ShowTaskInfoEvent(taskInfoDetailModel));
          }),
        );
      },
    );
  }
}
