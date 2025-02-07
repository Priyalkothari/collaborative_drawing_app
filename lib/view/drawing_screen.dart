import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/drawing_canvas.dart';
import '../viewModel/drawing_view_model.dart';

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({super.key});

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  final _transformationController = TransformationController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<DrawingViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Collaborative Drawing App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: viewModel.undo,
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            onPressed: viewModel.redo,
          ),
          IconButton(
            icon: viewModel.drawingZoomed ? const Icon(Icons.zoom_out_map) : const Icon(Icons.zoom_in),
            onPressed: () {
              if (viewModel.drawingZoomed) {
                _transformationController.value = Matrix4.identity();
                viewModel.resetTransform();
              } else {
                viewModel.updateZoomState(true);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: viewModel.drawingZoomed ? InteractiveViewer(
                transformationController: _transformationController,
                boundaryMargin: const EdgeInsets.all(50), // Allow moving beyond screen
                minScale: 0.5, // Minimum zoom out level
                maxScale: 4.0,
                child: paintBoard()) : GestureDetector(
              onPanStart: (details) {
                viewModel
                    .addPoint(details.localPosition);
              },
              onPanUpdate: (details) {
                if (!viewModel.drawingZoomed) {
                  viewModel
                      .updatePoint(details.localPosition);
                }
              },
              child: paintBoard(),
            )
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                DropdownButton<Color>(
                  value: Provider.of<DrawingViewModel>(context).selectedColor,
                  onChanged: (color) {
                    viewModel
                        .setColor(color!);
                  },
                  items: const [
                    DropdownMenuItem(
                      value: Colors.black,
                      child: Text('Black'),
                    ),
                    DropdownMenuItem(
                      value: Colors.red,
                      child: Text('Red'),
                    ),
                    DropdownMenuItem(
                      value: Colors.blue,
                      child: Text('Blue'),
                    ),
                  ],
                ),
                Slider(
                  value: Provider.of<DrawingViewModel>(context).selectedThickness,
                  min: 1,
                  max: 10,
                  onChanged: (value) {
                    viewModel
                        .setThickness(value);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(onPressed: () => viewModel.clearPoints(), child: const Icon(Icons.clear),),
    );
  }

  Widget paintBoard() => Consumer<DrawingViewModel>(
    builder: (context, viewModel, child) {
      return Container(
        color: Colors.white,
        child: CustomPaint(
          painter: DrawingCanvas(viewModel.points),
          size: Size.infinite,
        ),
      );
    },
  );
}