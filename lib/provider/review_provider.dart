import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/model/location.dart';
import '../data/model/review.dart';
import '../data/repository/review_repository.dart';
import 'package:uuid/uuid.dart';

// ReviewRepository 인스턴스를 제공하는 Riverpod Provider
final reviewRepositoryProvider = Provider((ref) => ReviewRepository());

// 특정 Location에 대한 리뷰 리스트를 관리하는 StateNotifierProvider (family modifier 사용)
final reviewProvider = StateNotifierProvider.family<ReviewNotifier, List<Review>, Location>((ref, loc) {
  return ReviewNotifier(ref.watch(reviewRepositoryProvider), loc);
});

// Review 데이터를 관리하고 변경하는 로직을 담는 StateNotifier
class ReviewNotifier extends StateNotifier<List<Review>> {
  final ReviewRepository repository;
  final Location location; // 현재 보고 있는 Location 정보

  ReviewNotifier(this.repository, this.location) : super([]) {
    loadReviews(); // 초기화 시점에 리뷰 로드
  }

  // 해당 Location의 리뷰를 불러오는 메서드
  Future<void> loadReviews() async {
    try {
      state = await repository.getReviews(location.mapX, location.mapY);
    } catch (e) {
      print('Failed to load reviews: $e');
      state = []; // 에러 발생 시 빈 리스트
    }
  }

  // 새로운 리뷰를 추가하는 메서드
  Future<void> addReview(String content) async {
    final review = Review(
      id: const Uuid().v4(), // 고유한 ID 생성
      content: content,
      mapX: location.mapX,
      mapY: location.mapY,
      createdAt: DateTime.now(), // 현재 시간 기록
    );
    try {
      await repository.addReview(review); // Firestore에 리뷰 저장
      state = [review, ...state]; // 상태에 새 리뷰 추가 (최신 리뷰가 위로)
    } catch (e) {
      print('Failed to add review: $e');
      // 에러 발생 시 사용자에게 알림 또는 다른 처리 추가 가능
    }
  }
}