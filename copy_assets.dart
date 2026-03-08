import 'dart:io';

void main() {
  final dir = Directory('assets');
  if (!dir.existsSync()) {
    dir.createSync();
    print('Created assets directory.');
  }

  final sourceFile = File(
    r'C:\Users\pkole\.gemini\antigravity\brain\c1520e05-d079-494e-b202-43d1b23b1553\world_gallery_ai_icon_1772831341291.png',
  );
  final targetFile = File(r'assets\icon.png');

  if (sourceFile.existsSync()) {
    sourceFile.copySync(targetFile.path);
    print('Copied icon successfully.');
  } else {
    print('Source file does not exist.');
  }
}
