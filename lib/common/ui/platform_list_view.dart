import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'colors.dart';
import 'text_style.dart';

abstract class PlatformListViewItems {
  final String title;
  final TextSpan? subtitle;

  PlatformListViewItems({required this.title, this.subtitle});

  PlatformListViewItems.withString(this.title, String? subtitleStr)
      : subtitle = subtitleStr != null
            ? TextSpan(style: AppBaseTextStyle.submainStyle, text: subtitleStr)
            : null;
}

class PlatformListView<T extends PlatformListViewItems>
    extends PlatformWidgetBase<CupertinoListSection, ListView> {
  final List<T> items;
  final Widget Function(BuildContext, int)? separatorBuilder;
  final void Function(T)? onTap;

  const PlatformListView(
      {super.key, required this.items, this.onTap, this.separatorBuilder});

  //TODO Remove
  @override
  Widget build(BuildContext context) {
    Widget listView = super.build(context);
    if (isMaterial(context)) {
      return listView;
    } else {
      return SingleChildScrollView(
        child: listView,
      );
    }
  }

  @override
  CupertinoListSection createCupertinoWidget(BuildContext context) {
    //TODO Think about adding header
    return CupertinoListSection.insetGrouped(
      hasLeading: false,
      backgroundColor: AppColors.surface,
      children: items.map((item) {
        return CupertinoListTile.notched(
          backgroundColor: AppColors.secondaryContainer,
          title: Text(item.title),
          subtitle: item.subtitle != null
              ? RichText(
                  text: item.subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          onTap: onTap != null
              ? () {
                  onTap!(item);
                }
              : null,
          trailing: onTap != null ? const CupertinoListTileChevron() : null,
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
            ? RichText(
                text: item.subtitle!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        onTap: onTap != null
            ? () {
                onTap!(item);
              }
            : null);
  }
}
