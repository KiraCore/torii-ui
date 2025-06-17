part of 'router.dart';

class ClaimProgressRouteExtra {
  const ClaimProgressRouteExtra({
    required this.signedTx,
    required this.msgSendFormModel,
    required this.pendingSenderTransaction,
    required this.pendingRecipientTransaction,
  });

  final TxListItemModel? signedTx;
  final MsgSendFormModel? msgSendFormModel;
  final TxListItemModel? pendingSenderTransaction;
  final TxListItemModel? pendingRecipientTransaction;
}
