import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/presentation/loading/cubit/loading_page_cubit.dart';
import 'package:torii_client/presentation/widgets/exports.dart';
import 'package:torii_client/utils/assets.dart';
import 'package:torii_client/utils/exports.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: BlocProvider<LoadingPageCubit>(
        create: (BuildContext context) => getIt<LoadingPageCubit>(),
        child: BlocConsumer<LoadingPageCubit, LoadingPageState>(
          listener: _handleLoadingPageStateChanged,
          builder: (BuildContext context, LoadingPageState state) {
            String networkName = state.networkStatusModel?.name ?? S.of(context).networkErrorUndefinedName;

            return Center(
              child: Padding(
                padding: EdgeInsets.only(top: 40, left: 15, right: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(Assets.assetsLogoLoading, height: 130, width: 130),
                    const SizedBox(height: 50),
                    Text(
                      S.of(context).networkConnectingTo('.', networkName),
                      textAlign: TextAlign.center,
                      style: textTheme.displaySmall!.copyWith(color: DesignColors.white1),
                    ),
                    const SizedBox(height: 67),
                    KiraOutlinedButton(
                      width: 192,
                      disabled: !state.canBeCanceled,
                      title: S.of(context).networkButtonCancelConnection,
                      onPressed: state.canBeCanceled ? context.read<LoadingPageCubit>().cancelConnection : null,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleLoadingPageStateChanged(BuildContext context, LoadingPageState state) {
    // TODO: custom navigation
    router.replace(const IntroRoute().location);
    // if (state.isConnected) {
    //   if (getIt<SessionCubit>().state.isLoggedIn) {
    //     router.replace(TransferRoute.initialRoute);
    //   } else {
    //     router.replace(const IntroRoute().location);
    //   }
    // } else if (state.connectionErrorType != null) {
    //   router.replace(const IntroRoute().location);
    // }
  }
}
