import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:torii_client/utils/assets.dart';
import 'package:torii_client/utils/browser/browser_url_controller.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/utils/network/app_config.dart';
import 'package:torii_client/utils/network/network_utils.dart';

class TokenAvatar extends StatelessWidget {
  final double size;
  final String? iconUrl;
  final AppConfig _appConfig = getIt<AppConfig>();

  TokenAvatar({required this.size, this.iconUrl = '', super.key});

  @override
  Widget build(BuildContext context) {
    Uri? proxyServerUri = _appConfig.proxyServerUri;
    bool proxyActiveBool =
        iconUrl != null &&
        NetworkUtils.shouldUseProxy(
          serverUri: Uri.parse(iconUrl!),
          proxyServerUri: proxyServerUri,
          appUri: const BrowserUrlController().uri,
        );
    String networkUri = proxyActiveBool ? '$proxyServerUri/${iconUrl.toString()}' : iconUrl ?? '';
    bool svgBool = networkUri.endsWith('.svg');

    Widget placeholderWidget = Padding(
      padding: EdgeInsets.all(size - size * 0.75),
      child: Image.asset(Assets.assetsLogoSignet),
    );

    Widget imageWidget;
    if (iconUrl == null || iconUrl!.isEmpty) {
      imageWidget = placeholderWidget;
    }
    if (svgBool) {
      imageWidget = SvgPicture.network(networkUri, placeholderBuilder: (_) => placeholderWidget);
    } else {
      imageWidget = CachedNetworkImage(imageUrl: networkUri, errorWidget: (_, __, ___) => placeholderWidget);
    }

    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(1),
      decoration: const BoxDecoration(shape: BoxShape.circle, color: DesignColors.grey3),
      child: CircleAvatar(backgroundColor: DesignColors.background, radius: size / 2, child: imageWidget),
    );
  }
}
