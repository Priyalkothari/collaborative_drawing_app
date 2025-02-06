import 'package:flutter/material.dart';

import '../model/drawing_point.dart';
import '../repostiory/drawing_repository.dart';

class DrawingViewModel with ChangeNotifier {
  final DrawingRepository _repository = DrawingRepository();
  List<DrawingPoint> _history = [];
  List<DrawingPoint> _undoStack = []; // Undone actions
  Color _selectedColor = Colors.black;
  double _selectedThickness = 2.0;

  // Zoom and pan state
  bool _isZoom = false;
  bool get drawingZoomed => _isZoom;

  List<DrawingPoint> get points => _history;
  Color get selectedColor => _selectedColor;
  double get selectedThickness => _selectedThickness;

  DrawingViewModel() {
    _loadDrawing();
  }

  void _loadDrawing() {
    _repository.getDrawingStream().listen((points) {
      _history = points;
      notifyListeners();
    });
  }

  void addPoint(Offset offset) {
    final point = DrawingPoint(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Unique ID
      offsets: [offset],
      color: _selectedColor,
      thickness: _selectedThickness,
    );
    _history.add(point);
    _undoStack.clear(); // Clear redo stack when a new action is performed
    notifyListeners();
    _repository.addDrawingPoint(point);
  }

  void updatePoint(Offset offset) {
    _history.last.color = _selectedColor;
    _history.last.thickness = _selectedThickness;
    _history.last.offsets.add(offset);
    notifyListeners();
    _repository.addDrawingPoint(_history.last);
  }

  void undo() {
    if (_history.isNotEmpty) {
      final lastPoint = _history.removeLast();
      _undoStack.add(lastPoint);
      notifyListeners();
      _repository.removeDrawingPoint(lastPoint.id);
    }
  }

  void redo() {
    if (_undoStack.isNotEmpty) {
      final lastUndonePoint = _undoStack.removeLast();
      _history.add(lastUndonePoint);
      notifyListeners();
      _repository.addDrawingPoint(lastUndonePoint);
    }
  }

  void setColor(Color color) {
    _selectedColor = color;
    notifyListeners();
  }

  void setThickness(double thickness) {
    _selectedThickness = thickness;
    notifyListeners();
  }

  void updateZoomState(bool isZoomed) {
    _isZoom = isZoomed;
    notifyListeners();
  }

  void resetTransform() {
    _isZoom = false;
    notifyListeners();
  }

  void clearPoints() {
    _history.clear();
    notifyListeners();
    _repository.deleteAllDrawingPoints();
  }
}