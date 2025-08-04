import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/review.dart';

class ReviewRepository {
  // Firebase Firestore의 'reviews' 컬렉션 참조
  final CollectionReference _collection = FirebaseFirestore.instance.collection('reviews');

  // 새로운 리뷰를 Firestore에 추가하는 메서드
  Future<void> addReview(Review review) async {
    try {
      // document ID를 review.id로 지정하여 저장
      await _collection.doc(review.id).set(review.toJson());
      print('Review added: ${review.content}');
    } catch (e) {
      print('Error adding review: $e');
      rethrow; // 에러를 다시 던져서 상위 계층에서 처리할 수 있도록 함
    }
  }

  // 특정 mapX, mapY 좌표에 해당하는 모든 리뷰를 Firestore에서 불러오는 메서드
  Future<List<Review>> getReviews(double mapX, double mapY) async {
    try {
      final snapshot = await _collection
          .where('mapX', isEqualTo: mapX)
          .where('mapY', isEqualTo: mapY)
          .orderBy('createdAt', descending: true) // 최신 리뷰가 먼저 오도록 정렬
          .get();
      // 불러온 문서들을 Review 객체 리스트로 변환
      return snapshot.docs.map((doc) => Review.fromJson(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error getting reviews: $e');
      return []; // 에러 발생 시 빈 리스트 반환
    }
  }
}