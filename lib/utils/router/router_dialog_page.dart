import 'package:flutter/material.dart';
import 'package:torii_client/presentation/widgets/drawer/kira_drawer.dart';
import 'package:torii_client/utils/exports.dart';

class RouterDialogPage<T> extends Page<T> {
  const RouterDialogPage({
    required this.builder,
    this.barrierDismissible = true,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  final WidgetBuilder builder;
  final bool barrierDismissible;

  @override
  Route<T> createRoute(BuildContext context) {
    return DialogRoute<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      useSafeArea: false,
      // TODO: color from theme
      barrierColor: router.isPreviousRouteDialog() ? Colors.transparent : const Color(0x66000000),
      settings: this,
      builder:
          (BuildContext context) => Dialog(
            alignment: Alignment.centerRight,
            insetPadding: const EdgeInsets.all(0),
            child: KiraDrawer(child: builder(context)),
          ),
    );
  }
}
