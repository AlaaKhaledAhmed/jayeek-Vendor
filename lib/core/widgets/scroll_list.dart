import 'package:flutter/material.dart';

class ScrollList extends StatelessWidget {
  final List<Widget> children;
  final ScrollPhysics? physics;
  final bool isHorizontal;
  final ScrollController? controller;
  final SliverAppBar? appBar;
  final bool? shrinkWrap;

  const ScrollList({
    super.key,
    this.isHorizontal = false,
    this.physics,
    this.controller,
    this.appBar,
    required this.children,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowIndicator();
        return true;
      },
      child: CustomScrollView(
        shrinkWrap: shrinkWrap ?? false,
        controller: controller,
        scrollDirection: isHorizontal ? Axis.horizontal : Axis.vertical,
        physics: physics ?? const BouncingScrollPhysics(),
        slivers: [
          ///add [SliverAppBar] if you wont
          if (appBar != null) appBar!,
          SliverList(delegate: SliverChildListDelegate(children)),
        ],
      ),
    );
  }
}
