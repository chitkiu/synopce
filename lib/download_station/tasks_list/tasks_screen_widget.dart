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
import 'domain/task_info_bloc.dart';
import 'domain/tasks_bloc.dart';

class TasksScreenWidget extends StatelessWidget {
  const TasksScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TasksBLoC>(
          create: (context) => TasksBLoC(TasksRepository(TasksInfoProvider()))
            ..add(LoadEvents()),
        ),
        BlocProvider(create: (context) => TaskInfoBloc())
      ],
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
                  tablet: _desktopWidget(list),
                  desktop: _desktopWidget(list),
                );
              }
              //TODO Add other state handling
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
    return BlocListener<TaskInfoBloc, TaskInfoState>(
      listener: (context, state) {
        if (state is ShowTaskInfoState) {
          if (state.task != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TaskInfoScreenWidget(state.task!)),
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
          return Expanded(
              child: (state is ShowTaskInfoState && state.task != null
                  ? TaskInfoScreenWidget(state.task!)
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
                  BlocProvider.of<TasksBLoC>(context)
                      .add(DeleteEvent(taskInfoDetailModel.id));
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
