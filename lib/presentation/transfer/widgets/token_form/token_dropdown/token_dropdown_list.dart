// import 'package:flutter/material.dart';
// import 'package:torii_client/domain/exports.dart';
// import 'package:torii_client/domain/models/tokens/token_amount_model.dart';
// import 'package:torii_client/presentation/transfer/widgets/token_form/token_dropdown/token_dropdown_list_item.dart';
// import 'package:torii_client/presentation/widgets/kira_list/infinity_list/popup_infinity_list/popup_infinity_list.dart';
// import 'package:torii_client/utils/exports.dart';

// class TokenDropdownList extends StatefulWidget {
//   final TokenAliasModel? initialTokenAliasModel;
//   final ValueChanged<TokenAmountModel> onTokenAmountModelSelected;
//   final FilterOption<TokenAmountModel>? initialFilterOption;
//   final AWalletAddress? walletAddress;

//   const TokenDropdownList({
//     required this.initialTokenAliasModel,
//     required this.onTokenAmountModelSelected,
//     this.initialFilterOption,
//     this.walletAddress,
//     super.key,
//   });

//   @override
//   State<StatefulWidget> createState() => _TokenDropdownList();
// }

// class _TokenDropdownList extends State<TokenDropdownList> {
//   final SortBloc<TokenAmountModel> sortBloc = SortBloc<TokenAmountModel>(
//     defaultSortOption: BalancesSortOptions.sortByDenom,
//   );
//   final FiltersBloc<TokenAmountModel> filtersBloc = FiltersBloc<TokenAmountModel>(
//     searchComparator: BalancesFilterOptions.search,
//   );

//   late final BalancesListController balancesListController = BalancesListController(
//     walletAddress: widget.walletAddress!,
//   );

//   TokenAliasModel? selectedTokenAliasModel;

//   @override
//   void initState() {
//     super.initState();
//     selectedTokenAliasModel = widget.initialTokenAliasModel;
//     if (widget.initialFilterOption != null) {
//       filtersBloc.add(FiltersAddOptionEvent<TokenAmountModel>(widget.initialFilterOption!));
//     }
//   }

//   @override
//   void dispose() {
//     sortBloc.close();
//     filtersBloc.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PopupInfinityList<TokenAmountModel>(
//       itemBuilder: (TokenAmountModel balance) {
//         TokenAliasModel tokenAliasModel = balance.tokenAliasModel;
//         return TokenDropdownListItem(
//           tokenAliasModel: tokenAliasModel,
//           selected: selectedTokenAliasModel == tokenAliasModel,
//           onTap: () => _handleItemSelected(balance),
//         );
//       },
//       listController: balancesListController,
//       singlePageSize: 20,
//       searchBarTitle: S.of(context).txSearchTokens,
//       sortBloc: sortBloc,
//       filtersBloc: filtersBloc,
//       favouritesBloc: favouritesBloc,
//     );
//   }

//   void _handleItemSelected(TokenAmountModel balance) {
//     selectedTokenAliasModel = balance.tokenAliasModel;
//     widget.onTokenAmountModelSelected.call(balance);
//     setState(() {});
//   }
// }
