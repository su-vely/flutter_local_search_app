import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repository/location_repository.dart';
import '../data/model/location.dart';

// LocationRepository 인스턴스를 제공하는 Provider (옵션: Dio 인스턴스 직접 생성)
// 이미 data/repository/location_repository.dart에 정의되어 있으므로 중복 제거 가능
// final locationRepositoryProvider = Provider((ref) => LocationRepository(Dio()));

// 지역 검색 결과를 관리하는 StateNotifierProvider
final locationProvider = StateNotifierProvider<LocationNotifier, List<Location>>((ref) {
  // locationRepositoryProvider를 통해 LocationRepository 인스턴스 주입
  return LocationNotifier(ref.watch(locationRepositoryProvider));
});

// Location 데이터를 관리하고 변경하는 로직을 담는 StateNotifier
class LocationNotifier extends StateNotifier<List<Location>> {
  final LocationRepository repository; // LocationRepository 의존성 주입

  LocationNotifier(this.repository) : super([]); // 초기 상태는 빈 리스트

  // 쿼리를 이용해 지역을 검색하고 상태를 업데이트하는 메서드
  Future<void> search(String query) async {
    try {
      final result = await repository.search(query);
      state = result; // 검색 결과를 상태로 업데이트
    } catch (e) {
      print('Failed to search locations: $e');
      state = []; // 에러 발생 시 상태 초기화
    }
  }
}