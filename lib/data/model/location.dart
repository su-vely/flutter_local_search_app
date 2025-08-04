class Location {
  final String title;
  final String category;
  final String roadAddress;
  final double mapX;
  final double mapY;

  Location({
    required this.title,
    required this.category,
    required this.roadAddress,
    required this.mapX,
    required this.mapY,
  });

  // JSON 데이터로부터 Location 객체를 생성하는 팩토리 메서드
  factory Location.fromJson(Map<String, dynamic> json) {
    // HTML 엔티티 제거 및 불필요한 태그 제거 (예: <b></b>)
    String cleanTitle = (json['title'] as String? ?? '')
        .replaceAll(RegExp(r'<\/?b>'), '');
    String cleanCategory = (json['category'] as String? ?? '')
        .replaceAll(RegExp(r'<\/?b>'), '');

    return Location(
      title: cleanTitle,
      category: cleanCategory,
      roadAddress: json['roadAddress'] ?? '주소 정보 없음',
      mapX: double.tryParse(json['mapx'].toString()) ?? 0.0,
      mapY: double.tryParse(json['mapy'].toString()) ?? 0.0,
    );
  }
}