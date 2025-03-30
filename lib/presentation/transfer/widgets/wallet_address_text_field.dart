import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/presentation/session/cubit/session_cubit.dart';
import 'package:torii_client/presentation/transfer/widgets/tx_input_wrapper.dart';
import 'package:torii_client/presentation/transfer/widgets/tx_text_field.dart';
import 'package:torii_client/presentation/widgets/avatar/kira_identity_avatar.dart';
import 'package:torii_client/utils/exports.dart';

class WalletAddressTextField extends StatefulWidget {
  final String label;
  final ValueChanged<AWalletAddress?> onChanged;
  final bool disabledBool;
  final AWalletAddress? defaultWalletAddress;

  /// Eth or Kira
  final bool needKiraAddress;

  const WalletAddressTextField({
    required this.label,
    required this.onChanged,
    required this.needKiraAddress,
    this.disabledBool = false,
    this.defaultWalletAddress,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _WalletAddressTextField();
}

class _WalletAddressTextField extends State<WalletAddressTextField> {
  final GlobalKey<FormFieldState<AWalletAddress>> formFieldKey = GlobalKey<FormFieldState<AWalletAddress>>();
  final TextEditingController textEditingController = TextEditingController();
  final ValueNotifier<AWalletAddress?> walletAddressNotifier = ValueNotifier<AWalletAddress?>(null);
  final SessionCubit sessionCubit = getIt<SessionCubit>();

  /// Text controller has ETH, [oppositeAddress] has KIRA, and vice versa.
  final ValueNotifier<String?> oppositeAddressNotifier = ValueNotifier<String?>(null);

  @override
  void initState() {
    super.initState();
    _assignDefaultValues();
  }

  @override
  void dispose() {
    formFieldKey.currentState?.dispose();
    textEditingController.dispose();
    walletAddressNotifier.dispose();
    oppositeAddressNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return FormField<AWalletAddress>(
      key: formFieldKey,
      validator: (_) => _validateAddress(),
      builder: (FormFieldState<AWalletAddress> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TxInputWrapper(
              hasErrors: field.hasError,
              builderWithFocus:
                  (FocusNode focusNode) => Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      KiraIdentityAvatar(address: walletAddressNotifier.value?.address, size: 45),
                      const SizedBox(width: 12),
                      BlocConsumer<SessionCubit, SessionState>(
                        bloc: sessionCubit,
                        listener: (BuildContext context, SessionState state) {
                          if (sessionCubit.state.isEthereumLoggedIn) {
                            _handleTextFieldChanged(textEditingController.text);
                          }
                        },
                        buildWhen:
                            (SessionState previous, SessionState current) =>
                                previous.isEthereumLoggedIn != current.isEthereumLoggedIn,
                        builder: (BuildContext context, SessionState state) {
                          return Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TxTextField(
                                focusNode: focusNode,
                                disabled: widget.disabledBool,
                                maxLines: 1,
                                hasErrors: field.hasError,
                                label: widget.label,
                                // situationally use the error as subtitle under the text
                                errorText: oppositeAddressNotifier.value,
                                errorStyle: textTheme.bodyMedium!.copyWith(color: DesignColors.grey1),
                                textEditingController: textEditingController,
                                onChanged: _handleTextFieldChanged,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
            ),
            if (field.errorText != null) ...<Widget>[
              const SizedBox(height: 7),
              Text(field.errorText!, style: textTheme.bodySmall!.copyWith(color: DesignColors.redStatus1)),
            ],
          ],
        );
      },
    );
  }

  Future<void> _assignDefaultValues() async {
    if (widget.defaultWalletAddress != null) {
      walletAddressNotifier.value = widget.defaultWalletAddress;
      textEditingController.text = widget.defaultWalletAddress!.address;
      if (sessionCubit.state.isEthereumLoggedIn) {
        // oppositeAddressNotifier.value = sessionCubit.tryFindOppositeAddress(widget.defaultWalletAddress!)?.address;
      }
    }
  }

  void _handleTextFieldChanged(String value) {
    String withCorrectAddress = value; //sessionCubit.replaceAddressTypeIfExists(value);
    AWalletAddress? walletAddress = _tryCreateWalletAddress(withCorrectAddress);

    walletAddressNotifier.value = walletAddress;
    if (withCorrectAddress == value) {
      if (sessionCubit.state.isEthereumLoggedIn && walletAddress != null) {
        // oppositeAddressNotifier.value = sessionCubit.tryFindOppositeAddress(walletAddress)?.address;
      } else {
        oppositeAddressNotifier.value = null;
      }
    } else {
      textEditingController.text = withCorrectAddress;
      oppositeAddressNotifier.value = value;
    }

    if (value.isEmpty) {
      formFieldKey.currentState?.reset();
    } else {
      formFieldKey.currentState?.validate();
    }
    widget.onChanged.call(walletAddress);
  }

  String? _validateAddress() {
    String addressText = textEditingController.text;
    AWalletAddress? walletAddress = _tryCreateWalletAddress(addressText);
    if (walletAddress == null ||
        (walletAddress is EthereumWalletAddress && widget.needKiraAddress) ||
        (walletAddress is CosmosWalletAddress && !widget.needKiraAddress)) {
      print('walletAddress errr: $walletAddress');
      return S.of(context).txErrorEnterValidAddress;
    }
    print('walletAddress not err: $walletAddress');
    return null;
  }

  AWalletAddress? _tryCreateWalletAddress(String? address) {
    if (address == null) {
      return null;
    }
    try {
      return AWalletAddress.fromAddress(address);
    } catch (e) {
      return null;
    }
  }
}
