import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      // Ambil kamera yang tersedia
      final cameras = await availableCameras();

      // Buat instance CameraController
      _controller = CameraController(cameras[0], ResolutionPreset.high);

      // Inisialisasi pengontrol kamera
      _initializeControllerFuture = _controller.initialize();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      // Tangani kesalahan
      print('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                      return CameraPreview(_controller);
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                Center(
                  child: CustomPaint(
                    size: Size(double.infinity, double.infinity),
                    painter: QRScannerOverlayPainter(),
                  ),
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
          : Center(
              child:
                  CircularProgressIndicator()), // Tampilkan indikator loading saat inisialisasi
    );
  }
}

class QRScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.5) // Warna hitam transparan
      ..style = PaintingStyle.fill;

    // Ukuran kotak pusat
    double boxSize = size.width * 0.8;

    // Posisi kotak pusat
    double left = (size.width - boxSize) / 2;
    double top = (size.height - boxSize) / 2.5;

    // Simpan layer yang ada dan mulai layer baru
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    // Gambar latar belakang semi-transparan
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );

    // Gambar kotak transparan di tengah
    paint.blendMode = BlendMode.clear;
    canvas.drawRect(
      Rect.fromLTWH(left, top, boxSize, boxSize),
      paint,
    
    );
   


    // Pulihkan canvas layer
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}