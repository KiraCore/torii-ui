part of 'transfer_claim_cubit.dart';

class TransferClaimState extends Equatable {
  final SignedTxModel? signedTx;
  final MsgSendFormModel? msgSendFormModel;
  final bool isReadyToClaim;
  final bool isClaiming;
  final bool isClaimed;

  /// Need to be claimed manually only when Ethereum is a recipient (Kira is a sender)
  final bool shouldBeManuallyClaimed;
  final int passedSeconds;

  const TransferClaimState({
    required this.signedTx,
    required this.msgSendFormModel,
    this.isReadyToClaim = false,
    this.isClaiming = false,
    this.isClaimed = false,
    this.passedSeconds = 0,
  }) : shouldBeManuallyClaimed = signedTx != null;

  @override
  List<Object?> get props => [signedTx, msgSendFormModel, isReadyToClaim, isClaiming, isClaimed, passedSeconds, shouldBeManuallyClaimed];
}
