import 'package:flutter/material.dart';
import 'package:torii_client/presentation/network/bloc/network_module_state.dart';
import 'package:torii_client/presentation/network/network_list/network_custom_section/network_custom_section_cubit.dart';
import 'package:torii_client/presentation/network/widgets/network_list_tile.dart';
import 'package:torii_client/presentation/widgets/exports.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/utils/network/network_utils.dart';

class NetworkCustomSectionContent extends StatefulWidget {
  final NetworkCustomSectionCubit networkCustomSectionCubit;
  final NetworkModuleState moduleState;

  const NetworkCustomSectionContent({
    required this.networkCustomSectionCubit,
    required this.moduleState,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _NetworkCustomSectionContent();
}

class _NetworkCustomSectionContent extends State<NetworkCustomSectionContent> {
  final ValueNotifier<String?> errorNotifier = ValueNotifier<String?>(null);
  final TextEditingController textFieldController = TextEditingController();

  @override
  void dispose() {
    errorNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    bool connectedNetworkExistsBool = widget.networkCustomSectionCubit.state.connectedNetworkStatusModel != null;
    bool lastConnectedNetworkExistsBool =
        widget.networkCustomSectionCubit.state.lastConnectedNetworkStatusModel != null;
    bool checkedNetworkExistsBool = widget.networkCustomSectionCubit.state.checkedNetworkStatusModel != null;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (connectedNetworkExistsBool) ...<Widget>[
          NetworkListTile(
            networkStatusModel: widget.networkCustomSectionCubit.state.connectedNetworkStatusModel!,
            moduleState: widget.moduleState,
          ),
        ] else if (lastConnectedNetworkExistsBool) ...<Widget>[
          NetworkListTile(
            networkStatusModel: widget.networkCustomSectionCubit.state.lastConnectedNetworkStatusModel!,
            moduleState: widget.moduleState,
          ),
        ],
        if (checkedNetworkExistsBool) ...<Widget>[
          if (connectedNetworkExistsBool) const SizedBox(height: 16),
          Text(
            S.of(context).networkCheckedConnection,
            style: textTheme.titleSmall!.copyWith(color: DesignColors.white2),
          ),
          NetworkListTile(
            networkStatusModel: widget.networkCustomSectionCubit.state.checkedNetworkStatusModel!,
            moduleState: widget.moduleState,
          ),
        ],
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: KiraTextField(controller: textFieldController, hint: S.of(context).networkHintCustomAddress),
        ),
        ValueListenableBuilder<String?>(
          valueListenable: errorNotifier,
          builder: (_, String? errorMessage, __) {
            if (errorMessage == null) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(errorMessage, style: textTheme.bodySmall!.copyWith(color: DesignColors.redStatus1)),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: KiraElevatedButton(
            title: S.of(context).networkButtonCheckConnection,
            onPressed: _pressCheckConnectionButton,
          ),
        ),
      ],
    );
  }

  Future<void> _pressCheckConnectionButton() async {
    Uri? uri = _buildUri();
    if (uri == null) {
      return;
    }
    textFieldController.clear();
    await widget.networkCustomSectionCubit.checkConnection(uri);
  }

  Uri? _buildUri() {
    bool addressValid = _validateNetworkAddress();
    if (addressValid == false) {
      return null;
    }
    Uri uri = _parseTextFieldToUri()!;
    return uri;
  }

  bool _validateNetworkAddress() {
    Uri? networkUri = _parseTextFieldToUri();
    String networkAddress = textFieldController.text;
    if (networkAddress.isEmpty) {
      errorNotifier.value = S.of(context).networkErrorAddressEmpty;
    } else if (networkUri == null) {
      errorNotifier.value = S.of(context).networkErrorAddressInvalid;
    } else {
      errorNotifier.value = null;
    }
    return errorNotifier.value == null;
  }

  Uri? _parseTextFieldToUri() {
    try {
      String networkAddress = textFieldController.text;
      Uri networkUri = NetworkUtils.parseUrlToInterxUri(networkAddress);
      return networkUri;
    } catch (_) {
      return null;
    }
  }
}
