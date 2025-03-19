extension IntExtension on int {
  String toTimeFromSeconds() {
    final hours = this ~/ 3600;
    final minutes = (this % 3600) ~/ 60;
    final seconds = this % 60;
    return hours > 0
        ? '$hours hours, $minutes minutes, $seconds seconds'
        : minutes > 0
        ? '$minutes minutes, $seconds seconds'
        : '$seconds seconds';
  }
}
