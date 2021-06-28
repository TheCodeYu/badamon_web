part of 'drag_view.dart';

abstract class DragBean {
  DragBean({
    this.index = 0,
    this.selected = false,
  });

  int index;
  bool selected;

  @override
  String toString() {
    return 'DragBean{index: $index, selected: $selected}';
  }
}
