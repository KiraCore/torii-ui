import 'package:flutter/material.dart';
import 'package:torii_client/presentation/widgets/loading/shimmer.dart';
import 'package:torii_client/utils/theme/design_colors.dart';

class PrefixedWidget extends StatelessWidget {
  final String prefix;
  final Widget? child;
  final bool loadingBool;
  final double height;
  final double width;
  final int? prefixMaxLines;
  final Widget? icon;

  const PrefixedWidget({
    required this.prefix,
    required this.child,
    this.loadingBool = false,
    this.height = 20,
    this.width = 80,
    this.prefixMaxLines,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      children: <Widget>[
        if (icon != null) ...<Widget>[icon!, const SizedBox(width: 12)],
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                prefix,
                maxLines: prefixMaxLines,
                overflow: prefixMaxLines != null ? TextOverflow.ellipsis : null,
                style: (child != null ? textTheme.bodySmall! : textTheme.bodyMedium!).copyWith(
                  color: DesignColors.accent,
                ),
              ),
              const SizedBox(height: 4),
              if (loadingBool)
                Shimmer(
                  child: ShimmerLoading(
                    isLoading: true,
                    child: Container(
                      height: height,
                      width: width,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                )
              else if (child == null)
                Text(
                  '---',
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium!.copyWith(color: DesignColors.white1),
                )
              else
                child!,
            ],
          ),
        ),
      ],
    );
  }
}
