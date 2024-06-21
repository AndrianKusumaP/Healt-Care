import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/widgets.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isCameraInitialized = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  QRViewController? _qrViewController;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      // Get available cameras
      final cameras = await availableCameras();

      // Create CameraController instance
      _controller = CameraController(cameras[0], ResolutionPreset.low);

      // Initialize camera controller
      _initializeControllerFuture = _controller.initialize();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      // Handle errors
      print('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _qrViewController?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _qrViewController = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      // Handle scanned data
      print('Scanned data: $scanData');
      // You can use scanData.code to get the scanned QR code or barcode
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Camera',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade900,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: _isCameraInitialized
          ? Stack(
              children: [
                FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return QRView(
                        key: qrKey,
                        onQRViewCreated: _onQRViewCreated,
                        overlay: QrScannerOverlayShape(
                          borderColor: Colors.red,
                          borderRadius: 10,
                          borderLength: 30,
                          borderWidth: 10,
                          cutOutSize: MediaQuery.of(context).size.width * 0.8,
                        ),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 60,
                    color: Colors.blue.shade900,
                    child: Center(),
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class QRScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    double boxSize = size.width * 0.8;
    double left = (size.width - boxSize) / 2;
    double top = (size.height - boxSize) / 2.5;

    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );

    paint.blendMode = BlendMode.clear;
    canvas.drawRect(
      Rect.fromLTWH(left, top, boxSize, boxSize),
      paint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
