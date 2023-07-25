import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:sizelabs_upc/src/product.dart';
import 'package:http/http.dart' as http;

class Reader extends StatefulWidget {
  final Function(UPCProduct?) onCodeRead;
  final Widget? loadingWidget;
  const Reader({
    super.key,
    required this.onCodeRead,
    this.loadingWidget,
  });

  @override
  State<Reader> createState() => _ReaderState();
}

class _ReaderState extends State<Reader> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: QrCamera(
        formats: const [
          BarcodeFormats.UPC_A,
          BarcodeFormats.UPC_E,
          BarcodeFormats.EAN_8,
          BarcodeFormats.EAN_13,
        ],
        qrCodeCallback: (code) => qrCodeCallback(code),
        child: loading
            ? widget.loadingWidget ?? const SizedBox()
            : const SizedBox(),
      ),
    );
  }

  Future<void> qrCodeCallback(code) async {
    try {
      if (loading) return;
      setState(() => loading = true);
      var product = await _getCodeData(code);
      if (!mounted) return;
      setState(() => loading = false);
      widget.onCodeRead(product);
    } catch (_) {
      rethrow;
    }
  }

  Future<UPCProduct?> _getCodeData(String code) async {
    try {
      final response = await http
          .get(Uri.parse('https://test-api-upc.sizelabs.co/upc?barcode=$code'));
      if (response.statusCode == 200) {
        return UPCProduct.fromJson(
            json.decode(response.body)['products'].first);
      }
      return null;
    } catch (_) {
      rethrow;
    }
  }
}
