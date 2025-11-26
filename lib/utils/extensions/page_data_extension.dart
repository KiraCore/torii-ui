import 'package:torii_client/domain/models/page_data.dart';
import 'package:torii_client/domain/models/tokens/list/tx_list_item_model.dart';

extension PageDataTxExtension on PageData<TxListItemModel> {
  PageData<TxListItemModel> sortDescByDate() {
    return copyWith(listItems: listItems..sort((a, b) => b.time.compareTo(a.time)));
  }
}

extension PageDataExtension on PageData {
  int get length => listItems.length;
}
