import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:http/http.dart' as http;

class UPCReader extends StatefulWidget {
  final String url;
  final Function(Map<String, dynamic>?) onCodeRead;
  final Function(Object?) onCodeReadError;
  final Function(String readedCode) onCodeNotFound;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final bool retriveData;
  const UPCReader({
    super.key,
    required this.onCodeRead,
    required this.onCodeReadError,
    required this.onCodeNotFound,
    this.loadingWidget,
    this.errorWidget,
    this.retriveData = true,
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
      if (!loading && widget.retriveData) {
        setState(() => loading = true);
        var product = await _getCodeData(code);
        if (!mounted) return;
        await Future.delayed(const Duration(seconds: 1));
        setState(() => loading = false);
        if (product.isNotEmpty) {
          widget.onCodeRead(product);
        }
      }
    } catch (_) {
      widget.onCodeReadError(_);
    }
  }

  Future<Map<String, dynamic>> _getCodeData(String code) async {
    try {
      final response =
          await http.get(Uri.parse('${widget.url}/upc?barcode=$code'));
      if (response.statusCode == 200) {
        final results =
            json.decode(response.body)['products'] as List<dynamic>? ?? [];
        debugPrint('results: $results');
        if (results.isNotEmpty) {
          return results.first as Map<String, dynamic>;
        } else {
          widget.onCodeNotFound(code);
          return {};
        }
      }
      throw Exception('Failed to load data');
    } catch (_) {
      rethrow;
    }
  }
}
