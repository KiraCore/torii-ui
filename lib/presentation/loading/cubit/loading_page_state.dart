part of 'loading_page_cubit.dart';

class LoadingPageState extends Equatable {
  final ANetworkStatusModel? networkStatusModel;
  final ConnectionErrorType? connectionErrorType;
  final bool isConnected;
  final bool canBeCanceled;

  const LoadingPageState({
    this.networkStatusModel,
    this.connectionErrorType,
    this.isConnected = false,
    this.canBeCanceled = false,
  });

  @override
  List<Object?> get props => <Object?>[networkStatusModel, connectionErrorType, isConnected, canBeCanceled];
}
