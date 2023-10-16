import 'package:flutter/material.dart';
import 'package:barcodescanner/barcode_scanner/barcode_scanner_overlay.dart';
import 'package:barcodescanner/barcode_scanner_error_widget.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void showBarcodeScannerBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (context) {
      return const BarcodeScannerBottomSheet();
    },
  );
}

class BarcodeScannerBottomSheet extends StatefulWidget {
  const BarcodeScannerBottomSheet({super.key});

  @override
  State<BarcodeScannerBottomSheet> createState() =>
      _BarcodeScannerBottomSheetState();
}

class _BarcodeScannerBottomSheetState extends State<BarcodeScannerBottomSheet> {
  @override
  void initState() {
    // widget.controller.stop();
    super.initState();
  }

  late MobileScannerController controller = MobileScannerController();
  Barcode? barcode;
  BarcodeCapture? capture;
  MobileScannerArguments? arguments;
  final double _height = 200;

  Future<void> onDetect(BarcodeCapture barcode) async {
    capture = barcode;
    setState(() => this.barcode = barcode.barcodes.first);
  }

  @override
  Widget build(BuildContext context) {
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.of(context).size.center(Offset.zero),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(
        builder: (context) {
          return Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text('Scan Product'),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: _height,
                child: Stack(
                  children: [
                    MobileScanner(
                      fit: BoxFit.cover,
                      scanWindow: scanWindow,
                      controller: controller,
                      onScannerStarted: (arguments) {
                        setState(() {
                          this.arguments = arguments;
                        });
                      },
                      errorBuilder: (context, error, child) {
                        return ScannerErrorWidget(error: error);
                      },
                      onDetect: onDetect,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                barcode?.displayValue ?? '',
              ),
            ],
          );
        },
      ),
    );
  }
}
