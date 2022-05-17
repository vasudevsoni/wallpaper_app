class WallPaperModel {
  String? photographerName;
  String? photgrapherUrl;
  int? photographerId;
  String? altText;
  SrcModel? src;

  WallPaperModel({
    this.photographerName,
    this.photgrapherUrl,
    this.photographerId,
    this.altText,
    this.src,
  });

  factory WallPaperModel.fromMap(Map<String, dynamic> jsonData) {
    return WallPaperModel(
      photographerName: jsonData['photographer'],
      photgrapherUrl: jsonData['photgrapher_url'],
      photographerId: jsonData['photographer_id'],
      altText: jsonData['alt'],
      src: SrcModel.fromMap(jsonData['src']),
    );
  }
}

class SrcModel {
  String? original;
  String? small;
  String? portrait;

  SrcModel({
    this.original,
    this.portrait,
    this.small,
  });

  factory SrcModel.fromMap(Map<String, dynamic> jsonData) {
    return SrcModel(
      original: jsonData['original'],
      portrait: jsonData['portrait'],
      small: jsonData['small'],
    );
  }
}
