import 'package:dsm_app/common/base_scaffold.dart';
import 'package:dsm_sdk/file_station/fs_file_info_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';

import '../../sdk.dart';

class SelectDestinationWidget extends StatelessWidget {
  final List<FSFileInfoModel> models;

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
    return BaseScaffold(
      barWidget: const Text("Select destination directory"),
      child: TreeView(
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
    if (data is FSFileInfoModel) {
      var icon;
      if (scope.isExpanded) {
        icon = Icons.expand_less;
      } else {
        icon = Icons.expand_more;
      }
      return GestureDetector(
          onTap: () async {
            if (scope.isExpanded) {
              scope.collapse(context);
            } else {
              var newDirs =
                  await SDK.instance.sdk.fsSDK.getFolderList(data.path);
              if (newDirs.isSuccess) {
                var items = newDirs.successValue
                    .where((element) => element.isDir)
                    .map((e) => TreeNode(
                          id: e.path,
                          data: e,
                        ))
                    .toList();
                scope.node.addChildren(items);
                scope.expand(context);
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
