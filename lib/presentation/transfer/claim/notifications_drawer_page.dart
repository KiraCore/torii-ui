import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:torii_client/domain/models/tokens/list/tx_list_item_model.dart';
import 'package:torii_client/presentation/global/logs/torii_logs_cubit.dart';
import 'package:torii_client/presentation/widgets/buttons/ink_wrapper.dart';
import 'package:torii_client/presentation/widgets/drawer/drawer_subtitle.dart';
import 'package:torii_client/presentation/widgets/key_value/copy_hover_title_value.dart';
import 'package:torii_client/presentation/widgets/key_value/detail_title_value.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/utils/extensions/page_data_extension.dart';

class NotificationsDrawerPage extends StatelessWidget {
  const NotificationsDrawerPage({super.key, this.hash});

  final String? hash;
  // todo
  static bool isNavigating = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ToriiLogsCubit, ToriiLogsState>(
      buildWhen: (previous, current) => previous.pendingEthTxs != current.pendingEthTxs,
      builder: (context, ToriiLogsState toriiLogsState) {
        List<TxListItemModel> list = toriiLogsState.pendingEthTxs?.sortDescByDate().listItems ?? [];
        if (hash != null && list.isNotEmpty && !isNavigating) {
          isNavigating = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            try {
              final item = list.where((element) => element.hash.toLowerCase() == hash!.toLowerCase()).firstOrNull;
              if (item != null) {
                ClaimDrawerRoute(item).push(context);
              }
            } catch (e) {
              getIt<Logger>().e('NotificationsDrawerPage.build: $e');
            }
          });
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: DrawerTitle(
                title: 'Notifications',
                subtitle: 'List contains both claimed and unclaimed transactions',
                subtitleColor: DesignColors.accent,
              ),
            ),
            if (list.isEmpty) ...[
              const SizedBox(height: 16),
              const Center(child: Text('Nothing yet')),
            ] else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: ListView.builder(
                  // TODO: remove shrinkWrap !!!!
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final model = list[index].txMsgModels.firstOrNull;
                    if (model == null) {
                      return const SizedBox.shrink();
                    }
                    return InkWrapper(
                      onTap: () {
                        ClaimDrawerRoute(list[index]).push(context);
                      },
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(DateFormat('dd/MM/yyyy, HH:mm:ss').format(list[index].time.toLocal()), maxLines: 2),
                          const SizedBox(height: 4),
                          CopyHoverTitleValue(
                            title: 'From',
                            value: model.fromWalletAddress.address,
                            hoverUsingIcon: true,
                            shortenAddress: true,
                          ),
                          const SizedBox(height: 4),
                          DetailTitleValue(title: 'Amount', value: model.tokenAmountModel.toString()),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
