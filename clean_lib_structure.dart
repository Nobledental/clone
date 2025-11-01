import 'dart:io';
import 'package:path/path.dart' as p;

void main() async {
  final rootDir = Directory.current;
  final correctLib = Directory(p.join(rootDir.path, 'lib'));

  if (!correctLib.existsSync()) {
    correctLib.createSync(recursive: true);
  }

  final allLibDirs = rootDir
      .listSync(recursive: true)
      .whereType<Directory>()
      .where((dir) => p.basename(dir.path) == 'lib' && dir.path != correctLib.path)
      .toList();

  print('🛠 Found ${allLibDirs.length} extra lib folders');

  for (final libDir in allLibDirs) {
    final dartFiles = libDir
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .toList();

    for (final file in dartFiles) {
      final relativePath = p.relative(file.path, from: libDir.path);
      final targetFile = File(p.join(correctLib.path, relativePath));

      if (targetFile.existsSync()) {
        final sourceContent = file.readAsStringSync();
        final targetContent = targetFile.readAsStringSync();

        if (sourceContent == targetContent) {
          print('🗑 Deleting duplicate: ${file.path}');
          file.deleteSync();
        } else {
          final backupFile = File(targetFile.path + '.backup');
          targetFile.renameSync(backupFile.path);
          file.renameSync(targetFile.path);
          print('⚠️ Conflict moved: ${targetFile.path} (original backed up)');
        }
      } else {
        targetFile.parent.createSync(recursive: true);
        file.renameSync(targetFile.path);
        print('✅ Moved: ${file.path} → ${targetFile.path}');
      }
    }
  }

  print('\n✅ Cleanup complete. All Dart files are centralized in lib/.');
}
