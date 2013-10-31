
part of cli;

/// A cli command which can be run with a [Runner].
///
/// For field descriptions, see corresponding parameters in
/// [Process.start], [Process.run], and [Process.runSync].
class Command {

  final String executable;
  final List<String> arguments;

  Command(this.executable, this.arguments);

  /// Returns the associated command line text.
  String toString() =>
      '$executable ${arguments.join(' ')}';
}
