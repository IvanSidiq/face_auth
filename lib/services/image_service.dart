import 'dart:io';
import 'package:image/image.dart' as imglib;

class ImageService {
  String drawRect(String path, int x, int y, int h, int w) {
    List<int> bytes = File(path).readAsBytesSync();
    imglib.Image? image = imglib.decodeImage(bytes);
    imglib.Image destImage = imglib.copyCrop(image!, x, y, h, w);
    List<int> jpg = imglib.encodeJpg(destImage);
    File(path).writeAsBytesSync(jpg);
    return path;
  }
}
