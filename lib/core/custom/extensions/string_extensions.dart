extension StringExtensions on String {
  bool isImageUrl() {
    return startsWith('http://') || startsWith('https://');
  }

  bool isFilePath() {
    return startsWith('/') || startsWith(RegExp(r'^[a-zA-Z]:\\'));
  }
}
