import 'package:flutter/cupertino.dart';
import 'package:torii_client/domain/models/wallet/mnemonic/mnemonic.dart';

import 'mnemonic_grid_generated_list_item.dart';

class MnemonicGridGenerated extends StatelessWidget {
  final Mnemonic mnemonic;
  final int columnsCount;
  final double cellGap;
  final double cellHeight;

  const MnemonicGridGenerated({
    required this.mnemonic,
    this.columnsCount = 2,
    this.cellGap = 10,
    this.cellHeight = 30,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columnsCount,
        mainAxisSpacing: cellGap,
        crossAxisSpacing: cellGap / 2,
        mainAxisExtent: cellHeight,
      ),
      itemCount: mnemonic.array.length,
      itemBuilder: (BuildContext context, int index) {
        return MnemonicGridGeneratedListItem(index: index, word: mnemonic.array[index]);
      },
    );
  }
}
