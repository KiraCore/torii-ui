part of 'transfer_input_cubit.dart';

class TransferInputState extends Equatable {
  final Wallet fromWallet;
  final TokenAmountModel? balance;

  const TransferInputState({required this.fromWallet, this.balance});

  @override
  List<Object?> get props => [fromWallet, balance];
}
