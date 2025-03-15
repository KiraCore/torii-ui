// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:miro/blocs/widgets/kira/kira_list/filters/models/filter_option.dart';
// import 'package:miro/blocs/widgets/transactions/token_form/token_form_cubit.dart';
// import 'package:miro/shared/models/balances/balance_model.dart';
// import 'package:miro/shared/models/wallet/address/a_wallet_address.dart';
// import 'package:miro/views/widgets/generic/pop_wrapper/pop_wrapper.dart';
// import 'package:miro/views/widgets/generic/pop_wrapper/pop_wrapper_controller.dart';
// import 'package:miro/views/widgets/generic/responsive/responsive_value.dart';
// import 'package:miro/views/widgets/transactions/token_form/token_dropdown/token_dropdown_button.dart';
// import 'package:miro/views/widgets/transactions/token_form/token_dropdown/token_dropdown_list.dart';
// import 'package:miro/views/widgets/transactions/tx_input_wrapper.dart';
// import 'package:torii_client/domain/models/tokens/token_amount_model.dart';
// import 'package:torii_client/presentation/transfer/widgets/token_form/cubit/token_form_cubit.dart';
// import 'package:torii_client/presentation/transfer/widgets/token_form/token_dropdown/token_dropdown_button.dart';
// import 'package:torii_client/presentation/transfer/widgets/tx_input_wrapper.dart';

// class TokenDropdown extends StatefulWidget {
//   final bool disabledBool;
//   final TokenAmountModel? defaultTokenAmountModel;
//   final FilterOption<TokenAmountModel>? initialFilterOption;
//   final AWalletAddress? walletAddress;

//   const TokenDropdown({
//     this.disabledBool = false,
//     this.defaultTokenAmountModel,
//     this.initialFilterOption,
//     this.walletAddress,
//     super.key,
//   });

//   @override
//   State<StatefulWidget> createState() => _TokenDropdown();
// }

// class _TokenDropdown extends State<TokenDropdown> {
//   final PopWrapperController popWrapperController = PopWrapperController();

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (BuildContext context, BoxConstraints boxConstraints) {
//         return PopWrapper(
//           disabled: widget.disabledBool,
//           popWrapperController: popWrapperController,
//           buttonBuilder: () => _buildSelectedTokenButton(boxConstraints),
//           popupBuilder: () => _buildPopupTokensList(boxConstraints),
//         );
//       },
//     );
//   }

//   Widget _buildSelectedTokenButton(BoxConstraints boxConstraints) {
//     return TxInputWrapper(
//       height: 80,
//       padding: EdgeInsets.zero,
//       child: Container(
//         width: boxConstraints.maxWidth,
//         padding: const EdgeInsets.all(16),
//         child: TokenDropdownButton(
//           tokenAliasModel: widget.defaultTokenAmountModel?.tokenAliasModel,
//           disabledBool: widget.disabledBool,
//         ),
//       ),
//     );
//   }

//   Widget _buildPopupTokensList(BoxConstraints boxConstraints) {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       width: boxConstraints.maxWidth,
//       height: 250,
//       constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
//       child: TokenDropdownList(
//         initialTokenAliasModel: widget.defaultTokenAmountModel?.tokenAliasModel,
//         initialFilterOption: widget.initialFilterOption,
//         onTokenAmountModelSelected: _handleTokenAmountModelChanged,
//         walletAddress: widget.walletAddress,
//       ),
//     );
//   }

//   void _handleTokenAmountModelChanged(TokenAmountModel balance) {
//     popWrapperController.hideTooltip();
//     if (widget.defaultTokenAmountModel != balance) {
//       BlocProvider.of<TokenFormCubit>(context).updateBalance(balance);
//     }
//   }
// }
