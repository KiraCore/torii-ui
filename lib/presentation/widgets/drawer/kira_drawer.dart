import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:torii_client/utils/exports.dart';

import 'drawer_app_bar.dart';

class KiraDrawer extends StatelessWidget {
  final Widget child;
  final double width;

  const KiraDrawer({required this.child, this.width = 400, super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (_, __) => GoRouter.of(context).pop,
      child: Drawer(
        backgroundColor: DesignColors.background,
        width: width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DrawerAppBar(
                // TODO: remove second param
                onClose: GoRouter.of(context).pop,
                onPop: GoRouter.of(context).pop,
              ),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 32), child: child),
            ],
          ),
        ),
      ),
    );
  }
}
