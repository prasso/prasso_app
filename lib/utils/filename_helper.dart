// ignore: avoid_classes_with_only_static_members
class FilenameHelper {
  static String getFilenameFromPath(String completePath) {
    final fileName = completePath.split('/').last;
    final filePath = completePath.replaceAll('/$fileName', '');
    print(fileName);
    print(filePath);
    return fileName;
  }
}
