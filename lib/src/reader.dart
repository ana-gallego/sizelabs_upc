import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:http/http.dart' as http;

class UPCReader extends StatefulWidget {
  final String url;
  final Function(Map<String, dynamic>?) onCodeRead;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  const UPCReader({
    super.key,
    required this.onCodeRead,
    this.loadingWidget,
    this.errorWidget,
    required this.url,
  });

  @override
  State<UPCReader> createState() => _UPCReaderState();
}

class _UPCReaderState extends State<UPCReader> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: QrCamera(
        formats: const [
          BarcodeFormats.UPC_A,
          BarcodeFormats.UPC_E,
        ],
        qrCodeCallback: (code) => qrCodeCallback(code),
        child: loading
            ? widget.loadingWidget ?? const SizedBox()
            : const SizedBox(),
        notStartedBuilder: (context) =>
            widget.loadingWidget ?? const SizedBox(),
        onError: (context, error) => widget.errorWidget ?? const SizedBox(),
      ),
    );
  }

  Future<void> qrCodeCallback(code) async {
    try {
      if (loading) return;
      setState(() => loading = true);
      var product = await _getCodeData('746775036720');
      if (!mounted) return;
      setState(() => loading = false);
      widget.onCodeRead(product);
    } catch (_) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> _getCodeData(String code) async {
    try {
      final response =
          await http.get(Uri.parse('${widget.url}/upc?barcode=$code'));
      if (response.statusCode == 200) {
        return json.decode(response.body)['products'].first;
      }
      return null;
    } catch (_) {
      print("chatch: $_");
      rethrow;
    }
  }
}
