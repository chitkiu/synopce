import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:synoapi/synoapi.dart';

import '../../../common/sdk.dart';

class SelectDestinationWidget extends StatelessWidget {
  final List<Directory> models;

  const SelectDestinationWidget(this.models, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var root = TreeNode(id: "Root");
    root.addChildren(
        models.where((element) => element.isDir ?? false).map((e) => TreeNode(
              id: e.path ?? "",
              data: e,
            )));
    var controller = TreeViewController(rootNode: root);
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: const Text("Select destination directory"),
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
    if (data is Directory) {
      var icon = Icons.expand_more;
      if (scope.isExpanded) {
        icon = Icons.expand_less;
      }

      return GestureDetector(
          onTap: () async {
            if (scope.isExpanded) {
              scope.collapse(context);
            } else {
              var newDirs =
                  await SDK.instance.fsSDK.list.listFolderFile(data.path ?? '/');
              if (newDirs.success && newDirs.data != null) {
                var items = newDirs.data!.files
                    .where((element) => element.isDir ?? false)
                    .map((e) => TreeNode(
                          id: e.path ?? "",
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
              data.name ?? "",
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
