import 'package:flutter/material.dart';
import 'package:torii_client/utils/exports.dart';

class TxDialog extends StatelessWidget {
  final Widget child;
  final String title;
  final double maxWidth;
  final List<String>? subtitle;
  final Widget? suffixWidget;

  const TxDialog({
    required this.child,
    required this.title,
    this.maxWidth = 616,
    this.subtitle,
    this.suffixWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: DesignColors.black, borderRadius: BorderRadius.circular(16)),
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(title, style: textTheme.displayMedium!.copyWith(color: DesignColors.white1)),
                        ),
                        if (suffixWidget != null) suffixWidget!,
                      ],
                    ),
                    if (subtitle != null) ...<Widget>[
                      const SizedBox(height: 12),
                      ...subtitle!
                          .map(
                            (String message) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Text(message, style: textTheme.bodyLarge!.copyWith(color: DesignColors.orange)),
                            ),
                          )
                          ,
                    ],
                    const SizedBox(height: 30),
                    child,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
