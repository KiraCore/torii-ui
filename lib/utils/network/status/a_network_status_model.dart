import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:torii_client/utils/network/app_config.dart';

abstract class ANetworkStatusModel extends Equatable {
  final Color _statusColor;
  final ConnectionStatusType connectionStatusType;
  final Uri? uri;
  final DateTime? lastRefreshDateTime;
  final String? _name;

  const ANetworkStatusModel({
    required Color statusColor,
    required this.connectionStatusType,
    required this.uri,
    this.lastRefreshDateTime,
    String? name,
  }) : _statusColor = statusColor,
       _name = name;

  String get name {
    return _name ?? uri?.host ?? 'Not connected';
  }

  Color get statusColor {
    return _statusColor;
  }

  ANetworkStatusModel copyWith({required ConnectionStatusType connectionStatusType, DateTime? lastRefreshDateTime});
}
