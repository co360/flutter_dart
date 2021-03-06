import 'package:flutter/material.dart';

/// [TabBarViewDynamic] is a dynamic TabBarView

class TabBarViewDynamic extends StatefulWidget {
  final Function(int) builder;
  final int activeIndex;
  final Function(int) onPositionChange;
  final Function(double) onScroll;
  final Function(TabController) onControllerChange;
  const TabBarViewDynamic({
    Key key,
    this.activeIndex = 0,
    this.onPositionChange,
    this.onScroll,
    this.onControllerChange,
    @required this.itemCount,
    @required this.builder,
  }) : super(key: key);
  final int itemCount;
  @override
  _TabViewBottomState createState() => _TabViewBottomState();
}

class _TabViewBottomState extends State<TabBarViewDynamic>
    with TickerProviderStateMixin {
  Widget getChild(int idx) {
    if (mounted && (idx == _currentPosition)) {
      return widget.builder(idx);
    } else
      return Container();
  }

  TabController controller;
  @override
  void initState() {
    _currentPosition = widget.activeIndex ?? 0;
    controller = TabController(
      length: widget.itemCount,
      vsync: this,
      initialIndex: _currentPosition,
    );
    controller.addListener(onPositionChange);
    controller.animation.addListener(onScroll);
    _currentCount = widget.itemCount;
    if (widget.onControllerChange != null)
      widget.onControllerChange(controller);
    super.initState();
  }

  @override
  void dispose() {
    controller.animation.removeListener(onScroll);
    controller.removeListener(onPositionChange);
    controller.dispose();
    super.dispose();
  }

  doChanged(int index) {
    tabView.children[index] = widget.builder(index);
  }

  int _currentCount = 0;
  int _currentPosition = 0;
  @override
  void didUpdateWidget(TabBarViewDynamic oldWidget) {
    if (_currentCount != widget.itemCount) {
      controller.animation.removeListener(onScroll);
      controller.removeListener(onPositionChange);
      controller.dispose();

      if (widget.activeIndex != null) {
        _currentPosition = widget.activeIndex;
      }

      if (_currentPosition > widget.itemCount - 1) {
        _currentPosition = widget.itemCount - 1;
        _currentPosition = _currentPosition < 0 ? 0 : _currentPosition;
        if (widget.onPositionChange != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              widget.onPositionChange(_currentPosition);
            }
          });
        }
      }

      _currentCount = widget.itemCount;
      setState(() {
        controller = TabController(
          length: widget.itemCount,
          vsync: this,
          initialIndex: _currentPosition,
        );
        controller.addListener(onPositionChange);
        controller.animation.addListener(onScroll);
        if (widget.onControllerChange != null)
          widget.onControllerChange(controller);
      });
    } else if (widget.activeIndex != null) {
      controller.animateTo(widget.activeIndex);
    }

    super.didUpdateWidget(oldWidget);
  }

  onPositionChange() {
    if (!controller.indexIsChanging) {
      _currentPosition = controller.index;

      setState(() {
        doChanged(_currentPosition);
      });
      if (widget.onPositionChange != null) {
        widget.onPositionChange(_currentPosition);
      }
    }
  }

  onScroll() {
    if (widget.onScroll != null) {
      widget.onScroll(controller.animation.value);
    }
  }

  TabBarView tabView;
  @override
  Widget build(BuildContext context) {
    return tabView = TabBarView(
      controller: controller,
      children: [for (var i = 0; i < widget.itemCount; i++) getChild(i)],
    );
  }
}
