part of 'transfer_input_cubit.dart';

class TransferInputState extends Equatable {
  final Wallet fromWallet;
  final TokenAmountModel? balance;
  final TokenAmountModel? senderAmount;
  final AWalletAddress? recipientWalletAddress;
  final TokenAmountModel? recipientAmount;
  final String? recipientAmountText;
  final TokenDenominationModel? recipientTokenDenomination;
  final bool changedBySender;

  const TransferInputState({
    required this.fromWallet,
    this.balance,
    this.senderAmount,
    this.recipientAmount,
    this.recipientAmountText,
    this.recipientWalletAddress,
    this.recipientTokenDenomination,
    this.changedBySender = false,
  });

  @override
  List<Object?> get props => [
    fromWallet,
    balance,
    senderAmount,
    recipientAmount,
    recipientAmountText,
    recipientWalletAddress,
    recipientTokenDenomination,
    changedBySender,
  ];
}
