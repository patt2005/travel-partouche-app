import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as ui;
import 'dart:math' as math;

import 'package:travel_partouche_app/constants/consts.dart';
import 'package:travel_partouche_app/pages/congratulation_page.dart';

class PuzzleWidget extends StatefulWidget {
  final String imageAssetPath;

  const PuzzleWidget({
    super.key,
    required this.imageAssetPath,
  });

  @override
  _PuzzleWidgetState createState() => _PuzzleWidgetState();
}

class _PuzzleWidgetState extends State<PuzzleWidget> {
  // lets setup our puzzle 1st

  // add test button to check crop work
  // well done.. let put callback for success put piece & complete all

  GlobalKey<_JigsawWidgetState> jigKey = GlobalKey<_JigsawWidgetState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Puzzle Game"),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(CupertinoIcons.back),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                // let make base for our puzzle widget
                Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(border: Border.all(width: 2)),
                  child: JigsawWidget(
                    callbackFinish: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (context) =>
                              const CongratulationsPage(coinsEarned: 33),
                        ),
                      );
                    },
                    callbackSuccess: () {
                      print("callbackSuccess");
                    },
                    key: jigKey,
                    child: Padding(
                      padding: const EdgeInsets.all(22.0),
                      child: Image(
                        fit: BoxFit.contain,
                        image: AssetImage(widget.imageAssetPath),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.02),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    style: const ButtonStyle(
                      padding: WidgetStatePropertyAll(
                        EdgeInsets.symmetric(vertical: 10),
                      ),
                      backgroundColor: WidgetStatePropertyAll(
                        Color(0xFFDEDEDE),
                      ),
                    ),
                    onPressed: () async {
                      await jigKey.currentState?.generaJigsawCropImage();
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Generate",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// make new widget name JigsawWidget
// let move jigsaw blok
class JigsawWidget extends StatefulWidget {
  Widget child;
  Function() callbackSuccess;
  Function() callbackFinish;
  JigsawWidget({
    super.key,
    required this.child,
    required this.callbackFinish,
    required this.callbackSuccess,
  });

  @override
  _JigsawWidgetState createState() => _JigsawWidgetState();
}

class _JigsawWidgetState extends State<JigsawWidget> {
  final GlobalKey _globalKey = GlobalKey();
  ui.Image? fullImage;
  Size size = Size.zero;

  List<List<BlockClass>> images = [];
  ValueNotifier<List<BlockClass>> blocksNotifier =
      ValueNotifier<List<BlockClass>>([]);
  late CarouselSliderController _carouselController;

  // to save current touch down offset & current index puzzle
  Offset _pos = Offset.zero;
  int _index = 0;

  Future<ui.Image?> _getImageFromWidget() async {
    final boundary =
        _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

    if (boundary == null) {
      // Handle the case where the boundary is null
      print('RenderRepaintBoundary is null');
      return null;
    }

    size = boundary.size;
    final img = await boundary.toImage();
    final byteData = await img.toByteData(format: ImageByteFormat.png);
    final pngBytes = byteData?.buffer.asUint8List();

    if (pngBytes == null) {
      // Handle the case where pngBytes is null
      print('Failed to convert image to bytes');
      return null;
    }

    if (byteData == null) {
      print('Failed to get ByteData from image');
      return null;
    }

    final uint8List = byteData.buffer.asUint8List();
    return ui.decodeImage(uint8List);
  }

  void resetJigsaw() {
    images.clear();
    blocksNotifier = ValueNotifier<List<BlockClass>>([]);
    // _carouselController = new CarouselController();
    blocksNotifier.notifyListeners();
    setState(() {});
  }

  Future<void> generaJigsawCropImage() async {
    // 1st we need create a class for block image
    images = [];

    // get image from out boundary

    fullImage ??= await _getImageFromWidget();

    // split image using crop

    int xSplitCount = 2;
    int ySplitCount = 2;

    // i think i know what the problom width & height not correct!
    double widthPerBlock =
        fullImage!.width / xSplitCount; // change back to width
    double heightPerBlock = fullImage!.height / ySplitCount;

    for (var y = 0; y < ySplitCount; y++) {
      // temporary images
      List<BlockClass> tempImages = [];

      images.add(tempImages);
      for (var x = 0; x < xSplitCount; x++) {
        int randomPosRow = math.Random().nextInt(2) % 2 == 0 ? 1 : -1;
        int randomPosCol = math.Random().nextInt(2) % 2 == 0 ? 1 : -1;

        Offset offsetCenter = Offset(widthPerBlock / 2, heightPerBlock / 2);

        // make random jigsaw pointer in or out

        ClassJigsawPos jigsawPosSide = ClassJigsawPos(
          bottom: y == ySplitCount - 1 ? 0 : randomPosCol,
          left: x == 0
              ? 0
              : -images[y][x - 1]
                  .jigsawBlockWidget
                  .imageBox
                  .posSide
                  .right, // ops.. forgot to dclare
          right: x == xSplitCount - 1 ? 0 : randomPosRow,
          top: y == 0
              ? 0
              : -images[y - 1][x].jigsawBlockWidget.imageBox.posSide.bottom,
        );

        double xAxis = widthPerBlock * x;
        double yAxis = heightPerBlock * y; // this is culprit.. haha

        // size for pointing
        double minSize = math.min(widthPerBlock, heightPerBlock) / 15 * 4;

        offsetCenter = Offset(
          (widthPerBlock / 2) + (jigsawPosSide.left == 1 ? minSize : 0),
          (heightPerBlock / 2) + (jigsawPosSide.top == 1 ? minSize : 0),
        );

        // change axis for posSideEffect
        xAxis -= jigsawPosSide.left == 1 ? minSize : 0;
        yAxis -= jigsawPosSide.top == 1 ? minSize : 0;

        // get width & height after change Axis Side Effect
        double widthPerBlockTemp = widthPerBlock +
            (jigsawPosSide.left == 1 ? minSize : 0) +
            (jigsawPosSide.right == 1 ? minSize : 0);
        double heightPerBlockTemp = heightPerBlock +
            (jigsawPosSide.top == 1 ? minSize : 0) +
            (jigsawPosSide.bottom == 1 ? minSize : 0);

        // create crop image for each block
        ui.Image temp = ui.copyCrop(
          fullImage!,
          x: xAxis.round(),
          y: yAxis.round(),
          width: widthPerBlockTemp.round(),
          height: heightPerBlockTemp.round(),
        );

        // get offset for each block show on center base later
        Offset offset = Offset(size.width / 2 - widthPerBlockTemp / 2,
            size.height / 2 - heightPerBlockTemp / 2);

        ImageBox imageBox = ImageBox(
          image: Image.memory(
            ui.encodePng(temp),
            fit: BoxFit.contain,
          ),
          isDone: false,
          offsetCenter: offsetCenter,
          posSide: jigsawPosSide,
          radiusPoint: minSize,
          size: Size(widthPerBlockTemp, heightPerBlockTemp),
        );

        images[y].add(
          BlockClass(
              jigsawBlockWidget: JigsawBlockWidget(
                imageBox: imageBox,
              ),
              offset: offset,
              offsetDefault: Offset(xAxis, yAxis)),
        );
      }
    }

    blocksNotifier.value = images.expand((image) => image).toList();
    // let random a bit so blok puzzle not in incremet order
    // ops..bug .. i found culprit.. seem RepaintBoundary return wrong width on render..fix 1st using height
    // as well
    blocksNotifier.value.shuffle();
    blocksNotifier.notifyListeners();
    // _index = 0;
    setState(() {});
  }

  @override
  void initState() {
    // let generate split image
    // forgot to initiate.. haha
    _index = 0;
    _carouselController = CarouselSliderController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size sizeBox = MediaQuery.of(context).size;

    return ValueListenableBuilder(
        valueListenable: blocksNotifier,
        builder: (context, List<BlockClass> blocks, child) {
          List<BlockClass> blockNotDone = blocks
              .where((block) => !block.jigsawBlockWidget.imageBox.isDone)
              .toList();
          List<BlockClass> blockDone = blocks
              .where((block) => block.jigsawBlockWidget.imageBox.isDone)
              .toList();

          return Container(
            // set height for jigsaw base
            child: Container(
              // color: Colors.red,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: sizeBox.width,
                    child: Listener(
                      // listener for move event & up
                      // lets proceed 1st
                      onPointerUp: (event) {
                        if (blockNotDone.isEmpty) {
                          resetJigsaw();
                          // can set callback for complete all piece
                          widget.callbackFinish.call();
                        }
                      },
                      onPointerMove: (event) {
                        Offset offset = event.localPosition - _pos;

                        blockNotDone[_index].offset = offset;

                        if ((blockNotDone[_index].offset -
                                    blockNotDone[_index].offsetDefault)
                                .distance <
                            5) {
                          // drag block close to default position will trigger this cond

                          blockNotDone[_index]
                              .jigsawBlockWidget
                              .imageBox
                              .isDone = true;
                          blockNotDone[_index].offset =
                              blockNotDone[_index].offsetDefault;

                          _index = 0;
                          // not allow index change after success put piece

                          blocksNotifier.notifyListeners();

                          // can set callback success put piece
                          widget.callbackSuccess.call();
                        }

                        setState(() {});
                      },
                      child: Stack(
                        children: [
                          if (blocks.isEmpty) ...[
                            RepaintBoundary(
                              key: _globalKey,
                              child: Container(
                                color: Colors.red,
                                height: double.maxFinite,
                                width: double.maxFinite,
                                child: widget.child,
                              ),
                            )
                          ],

                          // no errors...let show.. let use ValueNotifier for easy use
                          //  hye .. :) lets proceed
                          Offstage(
                            offstage: !(blocks
                                .isNotEmpty), // sorry.. forgot about this
                            child: Container(
                              color: Colors.white,
                              width: size.width,
                              height: size.height,
                              child: CustomPaint(
                                // lets draw line base for jigsaw so player can know what shape they want match
                                painter: JigsawPainterBackground(blocks),
                                child: Stack(
                                  children: [
                                    // we need split up block which done and not done
                                    if (blockDone.isNotEmpty)
                                      ...blockDone.map(
                                        (map) {
                                          return Positioned(
                                            left: map
                                                .offset.dx, // let turn off this
                                            top: map.offset.dy,
                                            child: Container(
                                              child: map.jigsawBlockWidget,
                                            ),
                                          );
                                        },
                                      ),
                                    if (blockNotDone.isNotEmpty)
                                      ...blockNotDone.asMap().entries.map(
                                        (map) {
                                          return Positioned(
                                            left: map.value.offset
                                                .dx, // let set default so we can see progress 1st .. yeayyy
                                            top: map.value.offset.dy,
                                            child: Offstage(
                                              offstage: !(_index ==
                                                  map.key), // will hide blok which not same index
                                              child: GestureDetector(
                                                // for event touch down to capture current offset on blok
                                                onTapDown: (details) {
                                                  if (map
                                                      .value
                                                      .jigsawBlockWidget
                                                      .imageBox
                                                      .isDone) return;

                                                  setState(() {
                                                    _pos =
                                                        details.localPosition;
                                                    _index = map.key;
                                                  });
                                                },
                                                child: Container(
                                                  child: map
                                                      .value.jigsawBlockWidget,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                      color: const Color(0xFFF1F1F1),
                      height: 100,
                      child: CarouselSlider(
                        carouselController: _carouselController,
                        options: CarouselOptions(
                          initialPage: _index,
                          height: 80,
                          aspectRatio: 1,
                          viewportFraction: 0.15,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: true,
                          disableCenter: false,
                          onPageChanged: (index, reason) {
                            _index = index;
                            setState(() {});
                          },
                        ),
                        items: blockNotDone.map((block) {
                          Size sizeBlock =
                              block.jigsawBlockWidget.imageBox.size;
                          return FittedBox(
                            child: SizedBox(
                              width: sizeBlock.width,
                              height: sizeBlock.height,
                              child: block.jigsawBlockWidget,
                            ),
                          );
                        }).toList(),
                      ))
                ],
              ),
            ),
          );
        });
  }
}

class JigsawPainterBackground extends CustomPainter {
  List<BlockClass> blocks;

  JigsawPainterBackground(this.blocks);

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black12
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    Path path = Path();

    // loop blocks so we can draw line at base
    for (var element in blocks) {
      Path pathTemp = getPiecePath(
        element.jigsawBlockWidget.imageBox.size,
        element.jigsawBlockWidget.imageBox.radiusPoint,
        element.jigsawBlockWidget.imageBox.offsetCenter,
        element.jigsawBlockWidget.imageBox.posSide,
      );

      path.addPath(pathTemp, element.offsetDefault);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class BlockClass {
  Offset offset;
  Offset offsetDefault;
  JigsawBlockWidget jigsawBlockWidget;

  BlockClass({
    required this.offset,
    required this.jigsawBlockWidget,
    required this.offsetDefault,
  });
}

class ImageBox {
  Widget image;
  ClassJigsawPos posSide;
  Offset offsetCenter;
  Size size;
  double radiusPoint;
  bool isDone;

  ImageBox({
    required this.image,
    required this.posSide,
    required this.isDone,
    required this.offsetCenter,
    required this.radiusPoint,
    required this.size,
  });
}

class ClassJigsawPos {
  int top, bottom, left, right;

  ClassJigsawPos({
    required this.top,
    required this.bottom,
    required this.left,
    required this.right,
  });
}

class JigsawBlockWidget extends StatefulWidget {
  ImageBox imageBox;
  JigsawBlockWidget({
    super.key,
    required this.imageBox,
  });

  @override
  _JigsawBlockWidgetState createState() => _JigsawBlockWidgetState();
}

class _JigsawBlockWidgetState extends State<JigsawBlockWidget> {
  // lets start clip crop image so show like jigsaw puzzle

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: PuzzlePieceClipper(imageBox: widget.imageBox),
      child: CustomPaint(
        foregroundPainter: JigsawBlokPainter(imageBox: widget.imageBox),
        child: widget.imageBox.image,
      ),
    );
  }
}

class JigsawBlokPainter extends CustomPainter {
  ImageBox imageBox;

  JigsawBlokPainter({
    required this.imageBox,
  });
  @override
  void paint(Canvas canvas, Size size) {
    // we make function so later custom painter can use same path
    // yeayyyy
    Paint paint = Paint()
      ..color = imageBox.isDone
          ? Colors.white.withOpacity(0.2)
          : Colors.white //will use later
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(
        getPiecePath(size, imageBox.radiusPoint, imageBox.offsetCenter,
            imageBox.posSide),
        paint);

    if (imageBox.isDone) {
      Paint paintDone = Paint()
        ..color = Colors.white.withOpacity(0.2)
        ..style = PaintingStyle.fill
        ..strokeWidth = 2;
      canvas.drawPath(
          getPiecePath(size, imageBox.radiusPoint, imageBox.offsetCenter,
              imageBox.posSide),
          paintDone);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PuzzlePieceClipper extends CustomClipper<Path> {
  ImageBox imageBox;
  PuzzlePieceClipper({
    required this.imageBox,
  });
  @override
  Path getClip(Size size) {
    // we make function so later custom painter can use same path
    return getPiecePath(
        size, imageBox.radiusPoint, imageBox.offsetCenter, imageBox.posSide);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

getPiecePath(
  Size size,
  double radiusPoint,
  Offset offsetCenter,
  ClassJigsawPos posSide,
) {
  Path path = Path();

  Offset topLeft = const Offset(0, 0);
  Offset topRight = Offset(size.width, 0);
  Offset bottomLeft = Offset(0, size.height);
  Offset bottomRight = Offset(size.width, size.height);

  // calculate top point on 4 point
  topLeft = Offset(posSide.left > 0 ? radiusPoint : 0,
          (posSide.top > 0) ? radiusPoint : 0) +
      topLeft;
  topRight = Offset(posSide.right > 0 ? -radiusPoint : 0,
          (posSide.top > 0) ? radiusPoint : 0) +
      topRight;
  bottomRight = Offset(posSide.right > 0 ? -radiusPoint : 0,
          (posSide.bottom > 0) ? -radiusPoint : 0) +
      bottomRight;
  bottomLeft = Offset(posSide.left > 0 ? radiusPoint : 0,
          (posSide.bottom > 0) ? -radiusPoint : 0) +
      bottomLeft;

  // calculate mid point for min & max
  double topMiddle = posSide.top == 0
      ? topRight.dy
      : (posSide.top > 0
          ? topRight.dy - radiusPoint
          : topRight.dy + radiusPoint);
  double bottomMiddle = posSide.bottom == 0
      ? bottomRight.dy
      : (posSide.bottom > 0
          ? bottomRight.dy + radiusPoint
          : bottomRight.dy - radiusPoint);
  double leftMiddle = posSide.left == 0
      ? topLeft.dx
      : (posSide.left > 0
          ? topLeft.dx - radiusPoint
          : topLeft.dx + radiusPoint);
  double rightMiddle = posSide.right == 0
      ? topRight.dx
      : (posSide.right > 0
          ? topRight.dx + radiusPoint
          : topRight.dx - radiusPoint);

  // solve.. wew

  path.moveTo(topLeft.dx, topLeft.dy);
  // top draw
  if (posSide.top != 0)
    path.extendWithPath(
        calculatePoint(Axis.horizontal, topLeft.dy,
            Offset(offsetCenter.dx, topMiddle), radiusPoint),
        Offset.zero);
  path.lineTo(topRight.dx, topRight.dy);
  // right draw
  if (posSide.right != 0)
    path.extendWithPath(
        calculatePoint(Axis.vertical, topRight.dx,
            Offset(rightMiddle, offsetCenter.dy), radiusPoint),
        Offset.zero);
  path.lineTo(bottomRight.dx, bottomRight.dy);
  if (posSide.bottom != 0)
    path.extendWithPath(
        calculatePoint(Axis.horizontal, bottomRight.dy,
            Offset(offsetCenter.dx, bottomMiddle), -radiusPoint),
        Offset.zero);
  path.lineTo(bottomLeft.dx, bottomLeft.dy);
  if (posSide.left != 0)
    path.extendWithPath(
        calculatePoint(Axis.vertical, bottomLeft.dx,
            Offset(leftMiddle, offsetCenter.dy), -radiusPoint),
        Offset.zero);
  path.lineTo(topLeft.dx, topLeft.dy);

  path.close();

  return path;
}

// design each point shape
calculatePoint(Axis axis, double fromPoint, Offset point, double radiusPoint) {
  Path path = Path();

  if (axis == Axis.horizontal) {
    path.moveTo(point.dx - radiusPoint / 2, fromPoint);
    path.lineTo(point.dx - radiusPoint / 2, point.dy);
    path.lineTo(point.dx + radiusPoint / 2, point.dy);
    path.lineTo(point.dx + radiusPoint / 2, fromPoint);
  } else if (axis == Axis.vertical) {
    path.moveTo(fromPoint, point.dy - radiusPoint / 2);
    path.lineTo(point.dx, point.dy - radiusPoint / 2);
    path.lineTo(point.dx, point.dy + radiusPoint / 2);
    path.lineTo(fromPoint, point.dy + radiusPoint / 2);
  }

  return path;
}
