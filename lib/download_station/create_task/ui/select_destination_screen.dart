import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:synoapi/synoapi.dart';

import '../../../common/data/api_service/api_service.dart';
import '../../../common/ui/app_bar_title.dart';
import '../../../common/ui/icons_constants.dart';

class SelectDestinationWidget extends StatelessWidget {
  final List<FileStationDirectory> models;

  const SelectDestinationWidget(this.models, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var root = TreeNode(id: "Root");
    root.addChildren(
        models.where((element) => element.isDir).map((e) => TreeNode(
              id: e.path,
              data: e,
            )));
    var controller = TreeViewController(rootNode: root);
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: const AppBarTitle("Select destination directory"),
      ),
      body: TreeView(
        controller: controller,
        nodeBuilder: (context, node) {
          return const NodeTreeView();
        },
      ),
    );
  }
}

class NodeTreeView extends StatelessWidget {
  const NodeTreeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scope = TreeNodeScope.of(context);
    var data = scope.node.data;
    if (data is FileStationDirectory) {
      var icon = expandMoreIcon(context);
      if (scope.isExpanded) {
        icon = expandLessIcon(context);
      }

      return GestureDetector(
          onTap: () async {
            if (scope.isExpanded) {
              scope.collapse(context);
            } else {
              try {
                var newDirs =
                    await ApiService.api.fsService.listFolderFile(data.path);
                var items = newDirs.files
                    .where((element) => element.isDir)
                    .map((e) => TreeNode(
                          id: e.path,
                          data: e,
                        ))
                    .toList();
                scope.node.addChildren(items);
                scope.expand(context);
              } on Exception {
                //Do nothing
              }
            }
          },
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            SizedBox(
              width: scope.indentation,
              height: double.infinity,
            ),
            Padding(
                padding: const EdgeInsets.all(2), child: Icon(icon, size: 20)),
            Expanded(
                child: Text(
              data.name,
              overflow: TextOverflow.ellipsis,
            )),
            TextButton(
              child: const Text("Select"),
              onPressed: () {
                Navigator.pop(context, data);
              },
            ),
          ]));
    } else {
      return Container();
    }
  }
}
