extension IntExtension on int {


  /// Converts milliseconds to 24-hour HH:MM format (e.g., "15:30")
  String toHHMM() {
    if (this < 0) return '00:00';

    final totalSeconds = this ~/ 1000;
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }
}

extension DoubleFormatting on double {
  /// Formats to 0 decimals if whole number, otherwise 2 decimals.
  /// Example:
  /// - 12.0 → "12"
  /// - 12.345 → "12.3"
  String formatTo2Decimals() => this % 1 == 0
      ? toStringAsFixed(0)
      : toStringAsFixed(1);
}