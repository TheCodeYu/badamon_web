part of 'drag_view.dart';

/// Object used to report movement events.
class MotionEvent {
  static const int actionDown = 0;
  static const int actionUp = 1;
  static const int actionMove = 2;

  MotionEvent();

  /// action.
  late int action;

  /// drag index.
  late int dragIndex;

  /// the global x coordinate system in logical pixels.
  late double globalX;

  /// the global y coordinate system in logical pixels.
  late double globalY;
}

/// on drag listener.
/// if return true, delete drag index child image. default return false.
typedef OnDragListener = bool Function(MotionEvent event, double itemWidth);
