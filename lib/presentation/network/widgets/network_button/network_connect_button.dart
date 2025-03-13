import 'package:flutter/material.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/utils/network/status/a_network_status_model.dart';

class NetworkConnectButton extends StatelessWidget {
  final ANetworkStatusModel networkStatusModel;
  final double opacity;
  final VoidCallback? onPressed;

  const NetworkConnectButton({required this.networkStatusModel, this.opacity = 1, this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      children: <Widget>[
        Opacity(
          opacity: opacity,
          child: OutlinedButton(
            onPressed: onPressed,
            style: ButtonStyle(
              overlayColor: WidgetStateProperty.resolveWith(_setOverlayColor),
              side: WidgetStateProperty.all(const BorderSide(color: DesignColors.greyOutline)),
              shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
            ),
            child: Text(
              S.of(context).networkButtonConnect.toUpperCase(),
              style: textTheme.labelLarge!.copyWith(color: DesignColors.white1, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }

  Color _setOverlayColor(Set<WidgetState> states) {
    return DesignColors.greyHover1;
  }
}
