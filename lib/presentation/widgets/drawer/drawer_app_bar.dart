import 'package:flutter/material.dart';

import 'drawer_pop_button.dart';

class DrawerAppBar extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onPop;

  const DrawerAppBar({required this.onClose, required this.onPop, super.key});

  @override
  Widget build(BuildContext context) {
    EdgeInsets appBarPadding = const EdgeInsets.only(top: 32, left: 20, right: 32, bottom: 32);
    return Container(
      padding: appBarPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[DrawerPopButton(onClose: onClose, onPop: onPop)],
      ),
    );
  }
}
