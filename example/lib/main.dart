import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sizelabs_upc/sizelabs_upc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () => _onClick(context),
          child: const Text('Click me'),
        ),
      ),
    );
  }

  _onClick(BuildContext context) {
    showDialog<UPCProduct?>(
      context: context,
      builder: (BuildContext context) => const ReaderDialog(),
    ).then((product) {
      log(product?.toRawJson() ?? 'No product returned');
    });
  }
}

class ReaderDialog extends StatefulWidget {
  const ReaderDialog({super.key});

  @override
  State<ReaderDialog> createState() => _ReaderDialogState();
}

class _ReaderDialogState extends State<ReaderDialog> {
  bool isReading = false;
  @override
  Widget build(BuildContext context) {
    return Material(
        child: SizedBox(
      height: 500,
      width: 300,
      child: Reader(
        onCodeRead: (x) async {
          try {
            await Future.delayed(const Duration(seconds: 1));
            if (isReading) return;
            if (mounted) {
              Navigator.of(context).pop(x);
              setState(() => isReading = true);
            }
          } catch (e) {
            print("Error: $e");
          }
        },
      ),
    ));
  }
}
