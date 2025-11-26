import 'package:flutter/material.dart';

class ToriiScaffold extends StatelessWidget {
  const ToriiScaffold({super.key, required this.child, this.hasAppBar = false});

  final bool hasAppBar;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hasAppBar ? AppBar(elevation: 0, backgroundColor: Colors.transparent) : null,
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(constraints: const BoxConstraints(minWidth: 768, maxWidth: 1280), child: child),
      ),
    );
  }
}
