part of 'transfer_claim_cubit.dart';

class TransferClaimState extends Equatable {
  final SignedTxModel? signedTx;
  final MsgSendFormModel? msgSendFormModel;
  final bool isReadyToClaim;
  final bool isClaiming;
  final bool isClaimed;
  final int passedSeconds;

  const TransferClaimState({
    required this.signedTx,
    required this.msgSendFormModel,
    this.isReadyToClaim = false,
    this.isClaiming = false,
    this.isClaimed = false,
    this.passedSeconds = 0,
  });

  @override
  List<Object?> get props => [signedTx, msgSendFormModel, isReadyToClaim, isClaiming, isClaimed, passedSeconds];
}
