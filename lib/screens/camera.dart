import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _qrViewController;
  bool _isQRViewCreated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _qrViewController?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_qrViewController != null) {
      if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
        _qrViewController!.pauseCamera();
      } else if (state == AppLifecycleState.resumed) {
        _qrViewController!.resumeCamera();
      }
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _qrViewController = controller;
      _isQRViewCreated = true;
    });
    controller.scannedDataStream.listen((scanData) {
      // Handle scanned data
      print('Scanned data: ${scanData.code}');
      // Pause scanning after a successful scan
      controller.pauseCamera();
      // Handle the scanned data, then resume scanning if needed
      // For example, show a dialog or navigate to another screen
      // and then call controller.resumeCamera() when ready
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera'),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Stack(
        children: [
          _isQRViewCreated ? Container() : Center(child: CircularProgressIndicator()), // Loading indicator while initializing
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.red,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              color: Colors.blue.shade900,
              child: Center(child: Text('Scan a QR code')),
            ),
          ),
        ],
      ),
    );
  }
}
