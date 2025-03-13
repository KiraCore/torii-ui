import 'package:intl/intl.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/utils/network/app_config.dart';

class BlockTimeModel {
  final AppConfig _appConfig = getIt<AppConfig>();
  final DateTime blockTime;

  BlockTimeModel(this.blockTime);

  factory BlockTimeModel.fromString(String blockTime) {
    return BlockTimeModel(DateTime.parse(blockTime));
  }

  bool isOutdated() {
    return durationSinceBlock.inMinutes > _appConfig.outdatedBlockDuration.inMinutes;
  }

  Duration get durationSinceBlock => DateTime.now().difference(blockTime);

  @override
  String toString() {
    return DateFormat('dd.MM.yyyy HH:mm').format(blockTime.toLocal());
  }
}
