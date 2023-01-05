import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synoapi/synoapi.dart';

import '../../common/colors.dart';
import '../../common/icons_constants.dart';
import '../../sdk.dart';
import '../create_task/add_download_screen.dart';
import '../task_info/task_info_screen.dart';
import '../task_info/task_info_updatable_widget.dart';
import 'data/tasks_info_updater.dart';
import 'data/tasks_model.dart';
import 'task_item_widget.dart';

class TaskScreen extends StatefulWidget {

  const TaskScreen({Key? key}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {

  final TasksInfoUpdater _updater = SDK.instance.updater;

  final PublishSubject<Task?> _selectedTask = PublishSubject<Task?>();

  @override
  void initState() {
    _updater.start();
    super.initState();
  }

  @override
  void dispose() {
    _updater.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TasksModel?>(
        initialData: null,
        stream: _updater.dataStream,
        builder: (BuildContext context, AsyncSnapshot<TasksModel?> snapshot) {
          bool isLoading = !snapshot.hasData || snapshot.data == null || snapshot.data?.isLoading != false;

          return PlatformScaffold(
            appBar: PlatformAppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Tasks list"),
                  if (isLoading)
                    const Padding(padding: EdgeInsets.only(left: 10)),
                  if (isLoading)
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
            body: _getDataWidget(
                !snapshot.hasData || snapshot.data == null,
                snapshot.data
            ),
          );
        }
    );
  }

  Widget _getDataWidget(bool isLoading, TasksModel? currentData) {
    if (isLoading) {
      return _loadingWidget();
    } else {
      return _getWidget(currentData!);
    }
  }

  Widget _getWidget(TasksModel currentData) {
    if (currentData is SuccessTasksModel) {
      var list = currentData.models;
      return SafeArea(
          child: ScreenTypeLayout(
            mobile: _mobileWidget(list),
            tablet: _desktopWidget(list),
            desktop: _desktopWidget(list),
          )
      );
    } else if (currentData is ErrorTasksModel) {
      var errorText = currentData.errorType.toString();
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
    } else {
      return _loadingWidget();
    }
  }

  Widget _loadingWidget() {
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

  void _onClick(BuildContext context) {
    Navigator.of(context).push(platformPageRoute(
        context: context, builder: (context) => const AddDownloadTaskWidget()));
  }

  Widget _mobileWidget(List<Task> items) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (items.isEmpty)
            PlatformText("No items")
          else
            Expanded(
                child: _getItemsList(
                  items,
                  (task) {
                    Navigator.push(
                      context,
                      platformPageRoute(
                          context: context,
                          builder: (context) => TaskInfoScreen(task)),
                    );
                  },
                )
            ),
        ],
      ),
    );
  }

  Widget _desktopWidget(List<Task> items) {
    return Row(
      children: [
        SizedBox(
          width: 300,
          child: _getItemsList(
            items, (task) {
              _selectedTask.add(task);
            },
          ),
        ),
        Container(width: 0.5, color: getDividerColor()),
        Expanded(
            child: StreamBuilder<Task?>(
              stream: _selectedTask.stream,
              initialData: null,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return _emptySelectedTask();
                }
                return TaskInfoUpdatableWidget(snapshot.data!);
              },
            )
        )
      ],
    );
  }

  Widget _emptySelectedTask() {
    return const Align(
      alignment: AlignmentDirectional.center,
      child: Text("Select item"),
    );
  }

  Widget _getItemsList(List<Task> items, void Function(Task task) onClick) {
    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        var taskInfoDetailModel = items[index];
        return GestureDetector(
          onTap: () {
            onClick(taskInfoDetailModel);
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
      separatorBuilder: (BuildContext context, int index) => Divider(color: getDividerColor()),
    );
  }

}
