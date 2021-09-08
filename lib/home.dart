import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'dart:ui' as ui;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<SignatureState> signatureKey = GlobalKey<SignatureState>();
  bool clipped = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (signatureKey.currentState != null) {
            print("---+++ ${signatureKey.currentState.points}");
          }
          setState(() {
            clipped = !clipped;
          });
        },
        child: Text(clipped ? "UnClip" : "Clip"),
      ),
      body: clipped == false
          ? Stack(
              children: [
                Center(
                  child: Image.network(
                    "https://i.picsum.photos/id/1008/5616/3744.jpg?hmac=906z84ml4jhqPMsm4ObF9aZhCRC-t2S_Sy0RLvYWZwY",
                    fit: BoxFit.contain,
                  ),
                ),
                Signature(
                  key: signatureKey,
                  color: Colors.blue,
                  strokeWidth: 2,
                  backgroundPainter: WatermarkPaint("2.0", "2.0"),
                  onSign: () {},
                ),
              ],
            )
          : Center(
              child: ClipPath(
                child: Image.network(
                  "https://i.picsum.photos/id/1008/5616/3744.jpg?hmac=906z84ml4jhqPMsm4ObF9aZhCRC-t2S_Sy0RLvYWZwY",
                ),
                clipper: MyClipper(signatureKey.currentState.points),
              ),
            ),
    );
  }
}

class WatermarkPaint extends CustomPainter {
  final String price;
  final String watermark;

  WatermarkPaint(this.price, this.watermark);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 10.8,
        Paint()..color = Colors.blue);
  }

  @override
  bool shouldRepaint(WatermarkPaint oldDelegate) {
    return oldDelegate != this;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatermarkPaint &&
          runtimeType == other.runtimeType &&
          price == other.price &&
          watermark == other.watermark;

  @override
  int get hashCode => price.hashCode ^ watermark.hashCode;
}

class MyClipper extends CustomClipper<Path> {
  List<Offset> offsets;

  MyClipper(this.offsets);

  @override
  Path getClip(Size size) {
    Path path = Path();

    Offset startingOffset = getStartingOffset(0);
    Offset endingOffset = getEndingOffset(offsets.length - 1);
//    path.moveTo(startingOffset.dx, startingOffset.dy);

    path.quadraticBezierTo(
        startingOffset.dx, startingOffset.dy, endingOffset.dx, endingOffset.dy);
    /* for (int i = 1; i < offsets.length; i++) {
      if (offsets[i] != null) {
        if (i < offsets.length - 1) {
          if (offsets[i + 1] != null) {
            path.lineTo(offsets[i].dx, offsets[i + 1].dx);
            path.lineTo(offsets[i].dy, offsets[i + 1].dy);

          }
        } else {
          path.lineTo(offsets[i].dx, offsets[0].dx);
          path.lineTo(offsets[i].dy, offsets[0].dy);
        }
      }
    } */
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;

  Offset getStartingOffset(int startingPoint) {
    if (offsets[startingPoint] != null) {
      return offsets[startingPoint];
    } else {
      startingPoint = startingPoint + 1;
      Offset offset = getStartingOffset(startingPoint);
      return offset;
    }
  }

  Offset getEndingOffset(int endingPoint) {
    if (offsets[endingPoint] != null) {
      return offsets[endingPoint];
    } else {
      endingPoint = endingPoint - 1;
      Offset offset = getEndingOffset(endingPoint);
      return offset;
    }
  }
}
