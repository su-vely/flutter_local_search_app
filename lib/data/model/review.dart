class Review {
  final String id;
  final String content;
  final double mapX;
  final double mapY;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.content,
    required this.mapX,
    required this.mapY,
    required this.createdAt,
  });

  // Review 객체를 JSON(Map) 형태로 변환하는 메서드 (Firestore 저장을 위함)
  Map<String, dynamic> toJson() => {
    'id': id,
    'content': content,
    'mapX': mapX,
    'mapY': mapY,
    'createdAt': createdAt.toIso8601String(), // 날짜를 ISO 8601 문자열로 저장
  };

  // JSON(Map) 데이터로부터 Review 객체를 생성하는 팩토리 메서드 (Firestore 불러오기를 위함)
  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json['id'] as String,
    content: json['content'] as String,
    mapX: (json['mapX'] as num).toDouble(),
    mapY: (json['mapY'] as num).toDouble(),
    createdAt: DateTime.parse(json['createdAt'] as String), // 문자열을 DateTime으로 파싱
  );
}