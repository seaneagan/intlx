
/// Convenience methods which forward to a default [Runner].
part of cli;

var _runner = new Runner();

/// Convenience for [Runner.start].
Future<Process> start(
    Command command,
    {String workingDirectory,
     Map<String, String> environment,
     bool includeParentEnvironment: true,
     bool runInShell: false}) => _runner.start(
    command.executable,
    command.arguments,
    workingDirectory: workingDirectory,
    environment: environment,
    includeParentEnvironment: includeParentEnvironment,
    runInShell: runInShell);

/// Convenience for [Runner.run].
Future<ProcessResult> run(
    Command command,
    {String workingDirectory,
     Map<String, String> environment,
     bool includeParentEnvironment: true,
     bool runInShell: false,
     Encoding stdoutEncoding: SYSTEM_ENCODING,
     Encoding stderrEncoding: SYSTEM_ENCODING}) => _runner.run(
    command.executable,
    command.arguments,
    workingDirectory: workingDirectory,
    environment: environment,
    includeParentEnvironment: includeParentEnvironment,
    runInShell: runInShell,
    stdoutEncoding: stdoutEncoding,
    stderrEncoding: stderrEncoding);

/// Convenience for [Runner.runSync].
ProcessResult runSync(
    Command command,
    {String workingDirectory,
     Map<String, String> environment,
     bool includeParentEnvironment: true,
     bool runInShell: false,
     Encoding stdoutEncoding: SYSTEM_ENCODING,
     Encoding stderrEncoding: SYSTEM_ENCODING}) => _runner.runSync(
    command.executable,
    command.arguments,
    workingDirectory: workingDirectory,
    environment: environment,
    includeParentEnvironment: includeParentEnvironment,
    runInShell: runInShell,
    stdoutEncoding: stdoutEncoding,
    stderrEncoding: stderrEncoding);
