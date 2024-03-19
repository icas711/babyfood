import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:babyfood/feature/presentation/pages/user/widgets/upload_widget.dart';
import 'package:babyfood/feature/presentation/providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _repaintBoundaryKey = GlobalKey();
final _movingRectKey = GlobalKey();

class ImageEditorScreen extends ConsumerWidget {


  const ImageEditorScreen({super.key});



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выделить аватарку'),
        actions: [
          IconButton(
            onPressed: () async {
              const double pixelRatio = 3.0;
              final RenderRepaintBoundary boundary =
                  _repaintBoundaryKey.currentContext!.findRenderObject()
                      as RenderRepaintBoundary;
              final Size widgetSize = boundary.size;
              final ui.Image image =
                  boundary.toImageSync(pixelRatio: pixelRatio);
              final MovingRectWrapperState state =
                  _movingRectKey.currentState as MovingRectWrapperState;
              final Offset rectCenterOffset = state.center;
              final Size rectSize = state.size;
              final imageByte = await generateImage(image, rectCenterOffset, rectSize, widgetSize, ref);
              var firebaseProvider = FirebaseFirestore.instance
                  .collection('accounts')
                  .doc(FirebaseAuth.instance.currentUser!.uid);
              await firebaseProvider.set({'image': Blob(Uint8List.view(imageByte!.buffer))});
context.goNamed('account');

            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Center(
        child: MovingRectWrapper(
          key: _movingRectKey,
          child: RepaintBoundary(
            key: _repaintBoundaryKey,
            child: (ref.watch(uploadImageProvider)!.path!=null)?Image.file(
              File(ref.watch(uploadImageProvider)!.path),
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                return const Center(
                    child: Text('Этот тип изображения не поддерживается'));
              },
            ):Container(),
          ),
        ),
      ),
    );
  }

  Future<ByteData?> generateImage(ui.Image image, Offset center, Size size, Size widgetSize,
      WidgetRef ref) async {
    print('widget.image.width ${image.width}');
    print('widget.size.width ${size.width}');
    final pixelRatio = image.width / widgetSize.width;
    final src = Rect.fromCenter(
      center: Offset(
        center.dx * pixelRatio,
        center.dy * pixelRatio,
      ),
      width: size.width * pixelRatio,
      height: size.height * pixelRatio,
    );
    final recorder = ui.PictureRecorder();

    final canvas =
        Canvas(recorder, Rect.fromLTWH(0.0, 0.0, size.width, size.width));
    final stroke = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke;

    canvas.drawRect(src, stroke);

    final dst = Rect.fromCenter(
      center: Offset(
        size.width / 2,
        size.height / 2,
      ),
      width: size.width,
      height: size.height,
    );
    canvas.drawImageRect(
      image,
      src,
      dst,
      Paint(),
    );

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.width.toInt(), size.height.toInt());
    final pngBytes = await img.toByteData(format: ImageByteFormat.png);
    ref.read(croppedImageProvider.notifier).update((state) => pngBytes);
    return pngBytes;
  }
}

class MovingRectWrapper extends StatefulWidget {
  const MovingRectWrapper({super.key, required this.child});

  final Widget child;

  @override
  State<MovingRectWrapper> createState() => MovingRectWrapperState();
}

class MovingRectWrapperState extends State<MovingRectWrapper> {
  Offset _focalPoint = Offset.zero;
  double _scale = 1.0;
  Matrix4 _matrix = Matrix4.identity();
  final double _width = 100.0;
  final double _height = 100.0;

  Offset get center => Offset(
        _matrix[12] + context.size!.width / 2 - _width / 2 + size.width / 2,
        _matrix[13] + context.size!.height / 2 - _height / 2 + size.height / 2,
      );

  Size get size => Size(
        _width * _matrix[0],
        _height * _matrix[5],
      );

  void _onReset() {
    setState(() {
      _matrix = Matrix4.identity();
      _scale = 1.0;
    });
  }

  void _onScaleStart(ScaleStartDetails details) {
    _focalPoint = details.focalPoint;
    _scale = 1.0;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    Matrix4 matrix = _matrix;

    final newFocalPoint = details.focalPoint;
    final offsetDelta = (newFocalPoint - _focalPoint);
    _focalPoint = newFocalPoint;
    final offsetDeltaMatrix = _getTranslateMatrix(offsetDelta);
    matrix = offsetDeltaMatrix * matrix;

    final newScale = details.scale;
    if (newScale != 1.0) {
      final scaleDelta = newScale / _scale;
      _scale = newScale;
      final scaleDeltaMatrix = _getScaleMatrix(scaleDelta);
      matrix = scaleDeltaMatrix * matrix;
    }

    setState(() {
      _matrix = matrix;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onDoubleTap: _onReset,
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      child: Stack(
        alignment: Alignment.center,
        children: [
          widget.child,
          Transform(
            transform: _matrix,
            child: SizedBox(
              width: _width,
              height: _height,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Matrix4 _getTranslateMatrix(Offset offsetDelta) {
  final dx = offsetDelta.dx;
  final dy = offsetDelta.dy;
  return Matrix4(
    1,
    0,
    0,
    0,
    // comments are used for readable formatting
    0,
    1,
    0,
    0,
    // of Matrix4 arguments
    0,
    0,
    1,
    0,
    //
    dx,
    dy,
    0,
    1, //
  );
}

Matrix4 _getScaleMatrix(double scale) {
  return Matrix4(
    scale,
    0,
    0,
    0,
    //
    0,
    scale,
    0,
    0,
    //
    0,
    0,
    1,
    0,
    //
    0,
    0,
    0,
    1, //
  );
}

