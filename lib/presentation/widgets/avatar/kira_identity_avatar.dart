import 'package:flutter/material.dart';
import 'package:torii_client/presentation/widgets/avatar/url_avatar_widget.dart';
import 'package:torii_client/presentation/widgets/exports.dart';
import 'package:torii_client/utils/exports.dart';

class KiraIdentityAvatar extends StatefulWidget {
  final double size;
  final bool loadingBool;
  final String? address;
  final String? avatarUrl;

  const KiraIdentityAvatar({required this.size, this.loadingBool = false, this.address, this.avatarUrl, super.key});

  @override
  State<StatefulWidget> createState() {
    return _KiraIdentityAvatarState();
  }
}

class _KiraIdentityAvatarState extends State<KiraIdentityAvatar> {
  @override
  Widget build(BuildContext context) {
    if (widget.loadingBool) {
      return Shimmer(child: ClipOval(child: ShimmerLoading(isLoading: true, height: widget.size, width: widget.size)));
    } else if (widget.address == null) {
      return Container(
        height: widget.size,
        width: widget.size,
        decoration: const BoxDecoration(shape: BoxShape.circle, color: DesignColors.grey2),
      );
    } else if (widget.avatarUrl == null) {
      return SizedBox(
        height: widget.size,
        width: widget.size,
        child: JdenticonGravatar(address: widget.address!, size: widget.size),
      );
    } else {
      return UrlAvatarWidget(address: widget.address!, url: widget.avatarUrl!, size: widget.size);
    }
  }
}
