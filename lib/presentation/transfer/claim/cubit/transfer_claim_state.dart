part of 'transfer_claim_cubit.dart';

class TransferClaimState extends Equatable {
  final SignedTxModel? signedTx;
  final MsgSendFormModel? msgSendFormModel;
  final PageData<TxListItemModel>? txs;
  final bool isReadyToClaim;
  final bool isClaiming;

  /// Need to be claimed manually only when Ethereum is a recipient (Kira is a sender)
  final bool shouldBeManuallyClaimed;
  final int passedSeconds;
  final bool navigateToInput;
  final bool isError;
  final bool isLoading;

  const TransferClaimState({
    required this.signedTx,
    required this.msgSendFormModel,
    this.txs,
    this.isReadyToClaim = false,
    this.isClaiming = false,
    this.passedSeconds = 0,
    this.navigateToInput = false,
    this.isError = false,
    this.isLoading = false,
  }) : shouldBeManuallyClaimed = signedTx != null;

  @override
  List<Object?> get props => [
    signedTx,
    msgSendFormModel,
    txs,
    isReadyToClaim,
    isClaiming,
    passedSeconds,
    shouldBeManuallyClaimed,
    navigateToInput,
    isError,
    isLoading,
  ];
}
