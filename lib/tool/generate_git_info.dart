// generate_git_info.dart
import 'dart:io';

void main() async {
  // Get current branch
  final branchResult = await Process.run('git', [
    'rev-parse',
    '--abbrev-ref',
    'HEAD',
  ]);
  final branch = (branchResult.stdout as String).trim();

  // Get latest tag (version)
  final tagResult = await Process.run('git', [
    'describe',
    '--tags',
    '--abbrev=0',
  ]);
  final tag = (tagResult.stdout as String).trim();

  // Get latest commit hash
  final commitResult = await Process.run('git', ['rev-parse', 'HEAD']);
  final commit = (commitResult.stdout as String).trim();

  // Get latest commit date
  final dateResult = await Process.run('git', [
    'log',
    '-1',
    '--format=%cd',
    '--date=iso',
  ]);
  final commitDate = (dateResult.stdout as String).trim();

  final file = File('lib/git_info.dart');
  await file.writeAsString('''
const String gitBranch = "$branch";
const String gitTag = "$tag";
const String gitCommit = "$commit";
const String gitCommitDate = "$commitDate";
''');
}
