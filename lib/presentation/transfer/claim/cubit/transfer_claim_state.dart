part of 'transfer_claim_cubit.dart';

class TransferClaimState extends Equatable {
  final TxListItemModel? signedTx;
  final MsgSendFormModel? msgSendFormModel;
  // TODO: fix type
  final TxListItemModel? pendingSenderTransaction;
  final TxListItemModel? pendingRecipientTransaction;
  final PageData<TxListItemModel>? txs;
  final bool isReadyToClaim;

  /// - as a sender waits for recipient to claim
  final bool waitForRecipientToClaim;

  /// Options:
  /// - on Claim button for my Ethereum
  /// - wait to claim automatically for my Kira
  final bool isClaiming;

  /// Need to be claimed manually only when Ethereum is a recipient (Kira is a sender)
  final bool shouldBeManuallyClaimed;
  final int passedSeconds;
  final int remainingSeconds;
  final bool navigateToInput;
  final bool isError;
  final bool isLoading;

  // TODO: refactor
  TxListItemModel? get txToProcess {
    return signedTx ?? pendingSenderTransaction ?? pendingRecipientTransaction;
  }

  const TransferClaimState({
    required this.signedTx,
    required this.msgSendFormModel,
    required this.pendingSenderTransaction,
    required this.pendingRecipientTransaction,
    this.txs,
    this.isReadyToClaim = false,
    this.waitForRecipientToClaim = false,
    this.shouldBeManuallyClaimed = false,
    this.isClaiming = false,
    this.passedSeconds = 0,
    this.remainingSeconds = 0,
    this.navigateToInput = false,
    this.isError = false,
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [
    signedTx,
    msgSendFormModel,
    pendingSenderTransaction,
    pendingRecipientTransaction,
    txs,
    isReadyToClaim,
    waitForRecipientToClaim,
    isClaiming,
    passedSeconds,
    remainingSeconds,
    shouldBeManuallyClaimed,
    navigateToInput,
    isError,
    isLoading,
  ];
}
