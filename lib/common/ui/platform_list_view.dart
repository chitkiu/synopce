import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:synopce/common/ui/text_style.dart';

abstract class PlatformListViewItems {
  final String title;
  final String? subtitle;

  PlatformListViewItems(this.title, this.subtitle);
}

class PlatformListView<T extends PlatformListViewItems>
    extends PlatformWidgetBase<CupertinoListSection, ListView> {
  final List<T> items;
  final Widget Function(BuildContext, int)? separatorBuilder;
  final void Function(T)? onTap;

  const PlatformListView(
      {super.key, required this.items, this.onTap, this.separatorBuilder});

  @override
  CupertinoListSection createCupertinoWidget(BuildContext context) {
    //TODO Think about adding header
    return CupertinoListSection.insetGrouped(
      hasLeading: false,
      children: items.map((item) {
        return CupertinoListTile.notched(
            title: Text(item.title),
            subtitle: item.subtitle != null
                ? Text(item.subtitle!)
                : null,
            onTap: onTap != null
                ? () {
                    onTap!(item);
                  }
                : null,
          trailing: onTap != null
              ? const CupertinoListTileChevron()
              : null,
        );
      }).toList(),
    );
  }

  @override
  ListView createMaterialWidget(BuildContext context) {
    if (separatorBuilder != null) {
      return ListView.separated(
        itemBuilder: _materialItemBuilder,
        itemCount: items.length,
        separatorBuilder: separatorBuilder!,
      );
    }
    return ListView.builder(
      itemBuilder: _materialItemBuilder,
      itemCount: items.length,
    );
  }

  Widget? _materialItemBuilder(BuildContext context, int index) {
    var item = items[index];
    return ListTile(
        title: Text(item.title, style: AppBaseTextStyle.mainStyle),
        subtitle: item.subtitle != null
            ? Text(item.subtitle!, style: AppBaseTextStyle.submainStyle)
            : null,
        onTap: onTap != null
            ? () {
                onTap!(item);
              }
            : null
    );
  }
}
