import 'package:equatable/equatable.dart';
import 'package:torii_client/domain/models/page_data.dart';
import 'package:torii_client/domain/models/tokens/list/tx_list_item_model.dart';
import 'package:torii_client/utils/extensions/page_data_extension.dart';

class LogTxs extends Equatable {
  const LogTxs({required this.fromKira, required this.fromEth});

  final PageData<TxListItemModel> fromKira;
  final PageData<TxListItemModel> fromEth;

  PageData<TxListItemModel> combineAndSortDesc() {
    final List<TxListItemModel> combinedList = [...fromKira.listItems, ...fromEth.listItems];
    print('fromEth.listItems');
    print(fromEth.listItems);
    print('fromKira.listItems');
    print(fromKira.listItems);
    return PageData<TxListItemModel>(listItems: combinedList).sortDescByDate();
  }

  // todo remove
  // factory LogTxs.fromJson(Map<String, dynamic> json) {
  //   final kiraTxs = json['cosmos']['result'] as List<dynamic>? ?? [];
  //   final ethTxs = json['ethereum']['result'] as List<dynamic>? ?? [];

  //   List<TxListItemModel> kiraTransactions = [];
  //   for (final tx in kiraTxs) {
  //     try {
  //       final transaction = TxListItemModel.fromDto(Transaction.fromJson(tx as Map<String, dynamic>));
  //       kiraTransactions.add(transaction);
  //     } catch (e) {
  //       getIt<Logger>().w('ToriiLogsService: Skip invalid Kira transaction $tx: $e');
  //     }
  //   }
  //   // Create PageData objects for Kira and Ethereum transactions
  //   final kiraPageData = PageData<TxListItemModel>(
  //     listItems: kiraTransactions,
  //     isLastPage: true,
  //     blockDateTime: DateTime.now(),
  //     cacheExpirationDateTime: DateTime.now(),
  //   );

  //   List<TxListItemModel> ethTransactions = [];
  //   for (final tx in ethTxs) {
  //     try {
  //       final transaction = TxListItemModel.fromDto(Transaction.fromJson(tx as Map<String, dynamic>));
  //       ethTransactions.add(transaction);
  //     } catch (e) {
  //       getIt<Logger>().w('ToriiLogsService: Skip invalid Eth transaction $tx: $e');
  //     }
  //   }

  //   final ethPageData = PageData<TxListItemModel>(
  //     listItems: ethTransactions,
  //     isLastPage: true,
  //     blockDateTime: DateTime.now(),
  //     cacheExpirationDateTime: DateTime.now(),
  //   );

  //   return LogTxs(fromKira: kiraPageData, fromEth: ethPageData);
  // }

  @override
  List<Object?> get props => <Object?>[fromKira, fromEth];
}
