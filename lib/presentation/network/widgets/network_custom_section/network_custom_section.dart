import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/presentation/network/bloc/network_module_state.dart';
import 'package:torii_client/presentation/network/network_list/network_custom_section/network_custom_section_cubit.dart';
import 'package:torii_client/presentation/network/network_list/network_custom_section/network_custom_section_state.dart';
import 'package:torii_client/presentation/network/widgets/network_custom_section/network_custom_section_content.dart';
import 'package:torii_client/utils/exports.dart';

class NetworkCustomSection extends StatefulWidget {
  final bool arrowEnabledBool;
  final NetworkModuleState moduleState;

  const NetworkCustomSection({required this.arrowEnabledBool, required this.moduleState, super.key});

  @override
  State<StatefulWidget> createState() => _NetworkCustomSection();
}

class _NetworkCustomSection extends State<NetworkCustomSection> {
  final NetworkCustomSectionCubit networkCustomSectionCubit = getIt<NetworkCustomSectionCubit>();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return BlocBuilder<NetworkCustomSectionCubit, NetworkCustomSectionState>(
      bloc: networkCustomSectionCubit,
      builder: (_, NetworkCustomSectionState networkCustomSectionState) {
        bool sectionExpandedBool = networkCustomSectionState.expandedBool;

        return SizedBox(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 17),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: <Widget>[
              //       Text(
              //         S.of(context).networkSwitchCustomAddress,
              //         style: textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w400, color: DesignColors.white1),
              //       ),
              //       Switch(
              //         value: sectionExpandedBool,
              //         onChanged: _handleSwitchChanged,
              //         activeColor: DesignColors.greenStatus1,
              //       ),
              //     ],
              //   ),
              // ),
              // if (sectionExpandedBool)
                NetworkCustomSectionContent(
                  networkCustomSectionCubit: networkCustomSectionCubit,
                  arrowEnabledBool: widget.arrowEnabledBool,
                  moduleState: widget.moduleState,
                ),
            ],
          ),
        );
      },
    );
  }

  void _handleSwitchChanged(bool expandedBool) {
    networkCustomSectionCubit.updateSwitchValue(expandedBool: expandedBool);
  }
}
