import 'package:collection/collection.dart'; // You have to add this manually, for some reason it cannot be added automatically
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:synoapi/synoapi.dart';

import '../../common/icons_constants.dart';
import '../../sdk.dart';
import '../create_task/add_download_screen.dart';
import '../task_info/task_info_screen_widget.dart';
import '../tasks_list/task_item_widget.dart';
import 'bloc/open_task_info/task_info_bloc.dart';
import 'bloc/open_task_info/task_info_event.dart';
import 'bloc/open_task_info/task_info_state.dart';
import 'bloc/tasks/tasks_bloc.dart';
import 'bloc/tasks/tasks_events.dart';
import 'bloc/tasks/tasks_state.dart';
import 'bloc/update_tasks/update_tasks_cubit.dart';
import 'bloc/update_tasks/update_tasks_state.dart';

class TasksScreenWidget extends StatelessWidget {
  const TasksScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<TasksBloc>(
            create: (context) =>
            TasksBloc(SDK.instance.repository)
              ..add(LoadTasksEvent()),
          ),
          BlocProvider(create: (context) => TaskInfoBloc()),
          BlocProvider(create: (context) => UpdateTasksCubit()),
        ],
        child: BlocBuilder<TasksBloc, TasksState>(builder: (context, state) {
          return PlatformScaffold(
            appBar: PlatformAppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Tasks list"),
                  if (state.isLoading)
                    const Padding(padding: EdgeInsets.only(left: 10)),
                  if (state.isLoading)
                    const SizedBox(
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
              cupertino: (context, platform) {
                return CupertinoNavigationBarData(
                    trailing: GestureDetector(
                      onTap: () {
                        _onClick(context);
                      },
                      child: addIcon(context),
                    ));
              },
            ),
            material: (context, platform) {
              return MaterialScaffoldData(
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      _onClick(context);
                    },
                    child: addIcon(context),
                  ));
            },
            body: BlocListener<UpdateTasksCubit, RequestUpdateTasks>(
                listener: (localContext, state) {
                  BlocProvider.of<TasksBloc>(context).add(LoadTasksEvent());
                }, child: BlocBuilder<TasksBloc, TasksState>(
              builder: (context, state) {
                switch (state.runtimeType) {
                  case SuccessTasksState:
                    var list = (state as SuccessTasksState).models.toList();
                    return SafeArea(
                        child: ScreenTypeLayout(
                          mobile: _mobileWidget(list),
                          tablet: _desktopWidget(list),
                          desktop: _desktopWidget(list),
                        ));
                  case ErrorTasksState:
                    var errorText = (state as ErrorTasksState).errorType.toString();
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
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                }
              },
            )),
          );
        }));
  }

  Widget _mobileWidget(List<Task> items) {
    return BlocListener<TaskInfoBloc, TaskInfoState>(
      listener: (context, state) {
        if (state is ShowTaskInfoState) {
          Navigator.push(
            context,
            platformPageRoute(
                context: context,
                builder: (context) => _taskInfoScreen(items, state)),
          );
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

  Widget _desktopWidget(List<Task> items) {
    return Row(
      children: [
        SizedBox(
          width: 300,
          child: _getItemsList(items),
        ),
        Container(width: 0.5, color: _getDividerColor()),
        BlocBuilder<TaskInfoBloc, TaskInfoState>(builder: (context, state) {
          if (state is ShowTaskInfoState) {
            return Expanded(child: _taskInfoScreen(items, state));
          }
          return const Expanded(
              child: Align(
                alignment: AlignmentDirectional.center,
                child: Text("Select item"),
              ));
        }),
      ],
    );
  }

  Widget _getItemsList(List<Task> items) {
    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        var taskInfoDetailModel = items[index];
        return GestureDetector(
              onTap: () {
                BlocProvider.of<TaskInfoBloc>(context)
                    .add(ShowTaskInfoEvent(taskInfoDetailModel));
              },
              child: Align(
                alignment: AlignmentDirectional.center,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: TaskItemWidget(taskInfoDetailModel),
                ),
              ),
            );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(color: _getDividerColor()),
    );
  }

  void _onClick(BuildContext context) {
    Navigator.of(context).push(platformPageRoute(
        context: context, builder: (context) => const AddDownloadTaskWidget()));
  }

  Widget _taskInfoScreen(List<Task> items,
      ShowTaskInfoState state) {
    return StreamBuilder(
      //TODO Try to find better way
      stream: SDK.instance.repository.successDataStream,
      initialData: items,
      builder: (context, snapshot) {
        var task = snapshot.data
            ?.firstWhereOrNull((element) => element.id == state.taskId);
        return TaskInfoScreenWidget(task);
      },
    );
  }

  Color _getDividerColor() {
    Brightness brightness = WidgetsBinding.instance.window.platformBrightness;

    if (brightness == Brightness.light) {
      return Colors.black;
    } else {
      return Colors.white;
    }
  }
}
