part of 'transfer_input_cubit.dart';

class TransferInputState extends Equatable {
  final Wallet fromWallet;
  final TokenAmountModel? balance;
  final TokenAmountModel? senderAmount;
  final AWalletAddress? recipientWalletAddress;
  final TokenAmountModel? recipientAmount;
  final bool changedBySender;

  const TransferInputState({
    required this.fromWallet,
    this.balance,
    this.senderAmount,
    this.recipientAmount,
    this.recipientWalletAddress,
    this.changedBySender = false,
  });

  @override
  List<Object?> get props => [
    fromWallet,
    balance,
    senderAmount,
    recipientAmount,
    recipientWalletAddress,
    changedBySender,
  ];
}
