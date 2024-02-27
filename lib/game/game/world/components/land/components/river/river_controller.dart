import 'dart:ui';

import 'package:flame/components.dart';

import '../../../../../../utils/game_utils.dart';
import '../../../../../grow_green_game.dart';

class RiverController {
  static const tag = 'RiverController';
  static const totalFrames = 6;
  static const timeEachFrame = 0.15;

  final List<Vector2> riverPositions;
  final int _imageWidth;
  final int _imageHeight;

  RiverController({
    required this.riverPositions,
  })  : _imageWidth = GameUtils().gameWorldSize.x.toInt(),
        _imageHeight = GameUtils().gameWorldSize.y.toInt();

  late GrowGreenGame game;
  late Image _riverImage;

  int _frameIndex = 0;
  double _elapsedTime = 0.0;

  /// A cache for all river tiles w.r.t each frame
  final Map<int, Image> _riverImageCache = {};
  final List<List<Image>> _frames = [];

  /// This method draws all the river's first frame in correct position
  Future<void> _drawRiverFrame(int frameIndex) async {
    assert(
      0 <= frameIndex && frameIndex < totalFrames,
      '$tag: _drawRiverFrame($frameIndex) invoked with an invalid frame index',
    );

    if (_riverImageCache.containsKey(frameIndex)) {
      _riverImage = _riverImageCache[frameIndex]!;
      return;
    }

    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final riverPaint = Paint();

    for (int i = 0; i < riverPositions.length; i++) {
      final riverPosition = riverPositions[i];
      final riverImage = _frames[i][frameIndex];
      canvas.drawImage(
        riverImage,
        Offset(riverPosition.x - riverImage.width / 2, riverPosition.y - riverImage.height),
        riverPaint,
      );
    }

    final picture = recorder.endRecording();
    final riverImage = await picture.toImage(_imageWidth, _imageHeight);
    _riverImageCache[frameIndex] = riverImage;
    _riverImage = riverImage;
  }

  Future<void> _loadAllFrames() async {
    for (int riverId = 1; riverId <= riverPositions.length; riverId++) {
      /// Load riverId's all frames
      final List<Image> riverIdFrames = [];
      for (int i = 1; i <= totalFrames; i++) {
        riverIdFrames.add(await game.images.load('river/$riverId/$i.png'));
      }
      _frames.add(riverIdFrames);
    }
  }

  Future<void> prepare({required GrowGreenGame game}) async {
    this.game = game;
    await _loadAllFrames();
    await _drawRiverFrame(_frameIndex);
  }

  void _drawNextFrame() {
    _elapsedTime = 0;
    _frameIndex = (_frameIndex + 1) % totalFrames;
    _drawRiverFrame(_frameIndex);
  }

  void update(double dt) {
    _elapsedTime += dt;
    if (_elapsedTime >= timeEachFrame) {
      _drawNextFrame();
    }
  }

  void render(Canvas canvas) {
    canvas.drawImage(
      _riverImage,
      Offset.zero,
      Paint(),
    );
  }
}
