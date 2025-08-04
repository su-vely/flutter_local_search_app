import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/location.dart';

class LocationRepository {
  final Dio dio;
  LocationRepository(this.dio);

  // 네이버 지역 검색 API를 호출하는 메서드
  Future<List<Location>> search(String query) async {
    try {
      final res = await dio.get(
        'https://openapi.naver.com/v1/search/local.json',
        queryParameters: {'query': query, 'display': 5}, // 5개만 표시
        options: Options(headers: {
          'X-Naver-Client-Id': '4TB7XQMly6cz36iJqLaH', // 본인의 ID로 교체
          'X-Naver-Client-Secret': 'SCnosuBZjm', // 본인의 Secret으로 교체
        }),
      );
      // 응답 데이터의 'items' 리스트를 Location 객체 리스트로 변환
      return (res.data['items'] as List)
          .map((e) => Location.fromJson(e))
          .toList();
    } on DioException catch (e) { // Dio 에러 처리
      print('Location search error: $e');
      // 에러 발생 시 빈 리스트 반환
      return [];
    } catch (e) { // 기타 에러 처리
      print('An unexpected error occurred during location search: $e');
      return [];
    }
  }
}

// LocationRepository 인스턴스를 제공하는 Riverpod Provider
final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return LocationRepository(Dio());
});