import 'package:flutter/material.dart';

class ToriiScaffold extends StatelessWidget {
  const ToriiScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(constraints: const BoxConstraints(minWidth: 768, maxWidth: 1280), child: child),
      ),
    );
  }
}
