import 'package:badamon_web/config/rx_config.dart';
import 'package:badamon_web/core/all_based.dart';
import 'package:badamon_web/core/icon_menu/icon_menu.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
part 'drag_event.dart';
part 'drag_icon.dart';

///拖拽单元
///
/// 实现桌面按钮的拖拽
///

class DragView extends StatefulWidget {
  const DragView(
      {Key? key,
      this.data = const [],
      this.space = 12,
      this.padding = EdgeInsets.zero,
      this.margin = EdgeInsets.zero,
      required this.itemBuilder,
      required this.initBuilder,
      required this.onDragListener,
      this.itemWidth = 45})
      : assert(itemWidth >= 10),
        super(key: key);

  /// picture data.
  final List<DragBean> data;

  /// The number of logical pixels between each child.
  final double space;

  /// View padding.
  final EdgeInsets padding;

  /// View margin.
  final EdgeInsets margin;

  /// Called to build children for the view.
  final IndexedWidgetBuilder itemBuilder;

  /// Called to build init children for the view.
  final WidgetBuilder initBuilder;

  /// On drag listener.
  final OnDragListener onDragListener;

  /// child width.
  final double itemWidth;

  @override
  _DragViewState createState() => _DragViewState();
}

class _DragViewState extends State<DragView>
    with TickerProviderStateMixin, AllBased {
  /// child transposition anim.
  late AnimationController _controller;

  /// child zoom anim.
  late AnimationController _zoomController;

  /// child float anim.
  late AnimationController _floatController;

  /// child positions.
  List<Rect> _positions = [];

  /// cache data.
  List<DragBean> _cacheData = [];

  /// drag child index.
  int _dragIndex = -1;

  /// drag child bean.
  DragBean? _dragBean;

  /// MotionEvent
  late MotionEvent _motionEvent;

  /// overlay entry.
  static OverlayEntry? _overlayEntry;

  /// child count.
  int _itemCount = 0;

  late Offset _downGlobalPos;
  late double _downLeft;
  late double _downTop;
  double _floatLeft = 0;
  double _floatTop = 0;
  double _fromTop = 0;
  double _fromLeft = 0;
  double _toTop = 0;
  double _toLeft = 0;
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    _zoomController =
        AnimationController(duration: Duration(milliseconds: 100), vsync: this);
    _floatController =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    _controller.addListener(() {
      setState(() {});
    });
    _zoomController.addListener(() {
      _updateOverlay();
    });
    _floatController.addListener(() {
      _floatLeft =
          _toLeft + (_fromLeft - _toLeft) * (1 - _floatController.value);
      _floatTop = _toTop + (_fromTop - _toTop) * (1 - _floatController.value);
      _updateOverlay();
    });
    _floatController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _clearAll();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _zoomController.dispose();
    _floatController.dispose();
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _init(context, widget.padding, widget.margin);

    // final int column = (_itemCount > 3 ? 3 : _itemCount + 1);
    // final int row = ((_itemCount + (_itemCount < 9 ? 1 : 0)) / 3).ceil();
    // final double realWidth = _itemWidth * column +
    //     widget.space * (column - 1) +
    //     widget.padding.horizontal;
    // final double realHeight =
    //     _itemWidth * row + widget.space * (row - 1) + widget.padding.vertical;
    final double left = widget.margin.left + widget.padding.left;
    final double top = widget.margin.top + widget.padding.top;
    return GestureDetector(
      onTap: () {
        rx.push(IconMenu.rx_event_IconMenu[0],
            data: {'focus': false, 'name': this.runtimeType.toString()});
      },
      onDoubleTap: () {
        rx.push(IconMenu.rx_event_IconMenu[0],
            data: {'focus': false, 'name': this.runtimeType.toString()});
        print('双击(b )');
      },
      onSecondaryTap: () {
        rx.push(IconMenu.rx_event_IconMenu[0],
            data: {'focus': false, 'name': this.runtimeType.toString()});
        print('右击(b )');
      },
      onLongPressStart: (details) {
        Offset offset = _getWidgetLocalToGlobal(context);
        _dragIndex = _getDragIndex(details.localPosition - Offset(left, top));
        if (_dragIndex == -1) return;
        _initIndex();
        widget.data[_dragIndex].selected = true;
        _dragBean = widget.data[_dragIndex];
        _downGlobalPos = details.globalPosition;
        _downLeft = left + _positions[_dragIndex].left;
        _downTop = top + _positions[_dragIndex].top;
        _toLeft = offset.dx + left + _positions[_dragIndex].left;
        _toTop = offset.dy + top + _positions[_dragIndex].top;
        _floatLeft = _toLeft;
        _floatTop = _toTop;
        Widget overlay = widget.itemBuilder(context, _dragIndex);
        _addOverlay(context, overlay);
        _triggerDragEvent(MotionEvent.actionDown);
        setState(() {});
      },
      onLongPressMoveUpdate: (details) {
        if (_dragIndex == -1) return;
        _floatLeft = _toLeft + (details.globalPosition.dx - _downGlobalPos.dx);
        _floatTop = _toTop + (details.globalPosition.dy - _downGlobalPos.dy);

        double left =
            _downLeft + (details.globalPosition.dx - _downGlobalPos.dx);
        double top = _downTop + (details.globalPosition.dy - _downGlobalPos.dy);
        Rect cRect =
            Rect.fromLTWH(left, top, widget.itemWidth, widget.itemWidth);
        int index = _getNextIndex(cRect, _positions[_dragIndex]);
        if (index != -1 && _dragIndex != index) {
          _initIndex();
          _dragIndex = index;
          widget.data.remove(_dragBean);
          widget.data.insert(_dragIndex, _dragBean!);
          _controller.reset();
          _controller.forward();
        }
        _updateOverlay();
        _triggerDragEvent(MotionEvent.actionMove);
      },
      onLongPressEnd: (details) {
        if (_dragIndex == -1) return;
        _fromLeft = _toLeft + (details.globalPosition.dx - _downGlobalPos.dx);
        _fromTop = _toTop + (details.globalPosition.dy - _downGlobalPos.dy);
        Offset offset = _getWidgetLocalToGlobal(context);
        _toLeft = offset.dx + left + _positions[_dragIndex].left;
        _toTop = offset.dy + top + _positions[_dragIndex].top;
      },
      onLongPressUp: () {
        _dragBean = null;
        // bool isCatch = _triggerDragEvent(MotionEvent.actionUp);
        // if (isCatch) {
        //   ///由前级返回true表示可以删除
        //   widget.data.removeAt(_dragIndex);
        //   _clearAll();
        // } else {
        //   _floatController.reset();
        //   _floatController.forward();
        // }
        _floatController.reset();
        _floatController.forward();
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        margin: widget.margin,
        padding: widget.padding,
        child: _buildChild(context),
      ),
    );
  }

  Widget _buildChild(BuildContext context) {
    List<Widget> children = [];

    if (_cacheData.isEmpty) {
      for (int i = 0; i < _itemCount; i++) {
        children.add(
          Positioned.fromRect(
            rect: _positions[i],
            child: widget.itemBuilder(context, i),
          ),
        );
      }
    } else {
      for (int i = 0; i < _itemCount; i++) {
        int curIndex = widget.data[i].index;
        int lastIndex = _cacheData[i].index;
        double left = _positions[curIndex].left +
            (_positions[lastIndex].left - _positions[curIndex].left) *
                _controller.value;
        double top = _positions[curIndex].top +
            (_positions[lastIndex].top - _positions[curIndex].top) *
                _controller.value;
        children.add(Positioned(
          left: left,
          top: top,
          width: widget.itemWidth,
          height: widget.itemWidth,
          child: Offstage(
            offstage: widget.data[i].selected == true,
            child: widget.itemBuilder(context, i),
          ),
        ));
      }
    }
    // if (_itemCount < 9) {
    //   children.add(Positioned.fromRect(
    //     rect: _positions[_itemCount],
    //     child: widget.initBuilder(context),
    //   ));
    // }
    return Stack(
      children: children,
    );
  }

  /// init child size and positions.
  void _init(BuildContext context, EdgeInsets padding, EdgeInsets margin) {
    double space = widget.space;
    double width = (MediaQuery.of(context).size.width -
        margin.horizontal -
        padding.horizontal);
    double height = (MediaQuery.of(context).size.height -
        margin.vertical -
        padding.vertical -
        dh(100));
    int h = width ~/ (widget.itemWidth + widget.space);
    int v = height ~/ (widget.itemWidth + widget.space);

    _itemCount = h * v;

    _itemCount = math.min(_itemCount, widget.data.length);

    _positions.clear();
    for (int i = 0; i < _itemCount; i++) {
      double left = (space + widget.itemWidth) * (i % h);
      double top = (space + widget.itemWidth) * (i ~/ h);
      _positions
          .add(Rect.fromLTWH(left, top, widget.itemWidth, widget.itemWidth));
    }
  }

  /// get widget global coordinate system in logical pixels.
  Offset _getWidgetLocalToGlobal(BuildContext context) {
    var box = context.findRenderObject();
    if (box != null) {
      return (box as RenderBox).localToGlobal(Offset.zero);
    }
    return Offset.zero;

    ///RenderBox? box = context.findRenderObject() ?? null;
    ///return box == null ? Offset.zero : box.localToGlobal(Offset.zero);
  }

  /// get drag index.
  int _getDragIndex(Offset offset) {
    for (int i = 0; i < _itemCount; i++) {
      if (_positions[i].contains(offset)) {
        return i;
      }
    }
    return -1;
  }

  /// init child index.
  void _initIndex() {
    for (int i = 0; i < _itemCount; i++) {
      widget.data[i].index = i;
    }
    _cacheData.clear();
    _cacheData.addAll(widget.data);
  }

  /// add overlay.
  void _addOverlay(BuildContext context, Widget overlay) {
    OverlayState? overlayState = Overlay.of(context);
    double space = widget.space;
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(builder: (BuildContext context) {
        return Positioned(
            left: _floatLeft, // - space * _zoomController.value,
            top: _floatTop, // - space * _zoomController.value,
            child: Material(
              color: Colors.transparent,
              child: Container(
                color: Colors.transparent,
                width: widget.itemWidth + space * _zoomController.value,
                height: widget.itemWidth + space * _zoomController.value,
                child: overlay,
              ),
            ));
      });

      overlayState?.insert(_overlayEntry!);
    } else {
      //重新绘制UI，类似setState
      _overlayEntry?.markNeedsBuild();
    }
    _zoomController.reset();
    _zoomController.forward();
  }

  /// update overlay.
  void _updateOverlay() {
    _overlayEntry?.markNeedsBuild();
  }

  /// remove overlay.
  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// get next child index.
  int _getNextIndex(Rect curRect, Rect origin) {
    if (_itemCount == 1) return 0;
    bool outside = true;
    for (int i = 0; i < _itemCount; i++) {
      Rect rect = _positions[i];
      bool overlaps = rect.overlaps(curRect);
      if (overlaps) {
        outside = false;
        Rect over = rect.intersect(curRect);
        Rect ori = origin.intersect(curRect);
        if (_getRectArea(over) > widget.itemWidth * (widget.itemWidth) / 2 ||
            _getRectArea(over) > _getRectArea(ori)) {
          return i;
        }
      }
    }
    int index = -1;
    if (outside) {
      if (curRect.bottom < 0) {
        index = _checkIndexTop(curRect);
      } else if (curRect.top > widget.itemWidth) {
        index = _checkIndexBottom(curRect);
      }
    }
    return index;
  }

  /// get area.
  double _getRectArea(Rect rect) {
    return rect.width * rect.height;
  }

  /// check top index.
  int _checkIndexTop(Rect other) {
    int index = -1;
    double? area;
    for (int i = 0; (i < 3 && i < _itemCount); i++) {
      Rect rect = _positions[i];
      Rect over = rect.intersect(other);
      double _area = _getRectArea(over);
      if (area == null || _area <= area) {
        area = _area;
        index = i;
      }
    }
    return index;
  }

  /// check bottom index.
  int _checkIndexBottom(Rect other) {
    int tagIndex = -1;
    double? area;
    for (int i = 0; (i < 3 && i < _itemCount); i++) {
      Rect _rect = _positions[i];
      Rect over = _rect.intersect(other);
      double _area = _getRectArea(over);
      if (area == null || _area <= area) {
        area = _area;
        tagIndex = i;
      }
    }
    if (tagIndex != -1) {
      for (int i = _itemCount - 1; i >= 0; i--) {
        if (((i + 1) / 3).ceil() >= (((_dragIndex + 1) / 3).ceil()) &&
            (i % 3 == tagIndex)) {
          return i;
        }
      }
    }
    return -1;
  }

  /// clear all.
  void _clearAll() {
    _removeOverlay();
    _cacheData.clear();
    int count = math.min(_itemCount, widget.data.length);
    for (int i = 0; i < count; i++) {
      widget.data[i].index = i;
      widget.data[i].selected = false;
    }
    setState(() {});
  }

  /// trigger drag event.
  bool _triggerDragEvent(int action) {
    if (_dragIndex != -1) {
      _motionEvent = MotionEvent();
      _motionEvent.dragIndex = _dragIndex;
      _motionEvent.action = action;
      _motionEvent.globalX = _floatLeft;
      _motionEvent.globalY = _floatTop;
      return widget.onDragListener(_motionEvent, widget.itemWidth);
    }
    return false;
  }
}
