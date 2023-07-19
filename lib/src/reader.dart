import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:sizelabs_upc/src/product.dart';
import 'package:http/http.dart' as http;

class Reader extends StatefulWidget {
  final Function(Product?) onCodeRead;
  const Reader({super.key, required this.onCodeRead});

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
            ? Container(
                color: Colors.black12,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                        child: CircularProgressIndicator(
                      color: Colors.white,
                    )),
                    SizedBox(height: 16),
                    Center(
                        child: Text(
                      "Loading...",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    )),
                  ],
                ))
            : const SizedBox(),
      ),
    );
  }

  Future<void> qrCodeCallback(code) async {
    if (loading) return;
    setState(() => loading = true);
    var product = await _getCodeData(code);
    setState(() => loading = false);
    widget.onCodeRead(product);
  }

  Future<Product?> _getCodeData(String code) async {
    try {
      final response = await http.get(
          Uri.parse('https://wilkins-upc-dev.sizelabs.co/upc?barcode=$code'));
      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body)['products'].first);
      }
      throw Exception('Failed to load product');
    } catch (e) {
      return null;
    }
  }
}
