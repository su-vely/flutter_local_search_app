# 📍 Local Search App
지역 검색 및 리뷰 작성을 위한 Flutter 애플리케이션입니다. 사용자는 Naver Local Search API를 통해 다양한 장소를 검색하고, Firebase Firestore를 활용하여 검색된 장소에 대한 리뷰를 작성하고 조회할 수 있습니다.

**✨ 주요 기능**
- **장소 검색** : Naver Local Search API를 사용하여 특정 키워드(예: "부산")로 장소를 검색하고 상세 정보를 조회합니다.

- **리뷰 작성** : 검색된 장소에 대한 사용자의 경험을 텍스트 리뷰로 작성하여 저장합니다.

- **리뷰 조회** : 선택된 장소에 이미 작성된 모든 리뷰 목록을 불러와 확인합니다.

- **직관적인 UI** : Material Design 가이드라인을 따라 깔끔하고 사용자 친화적인 인터페이스를 제공합니다.
<br>

**🛠 기술 스택**

- **Flutter** : 크로스 플랫폼 모바일 애플리케이션 개발 프레임워크

- **Dart** : Flutter 개발 언어

- **Riverpod** : 선언적이고 간결한 상태 관리를 위한 프레임워크

- **Dio** : 강력한 HTTP 클라이언트 (Naver Local Search API 통신)

- **Firebase Firestore** : NoSQL 클라우드 데이터베이스 (리뷰 데이터 저장 및 관리)

- **intl** : 날짜 및 시간 포맷팅 유틸리티
<br>

**🚀 시작하기**

**📦 의존성 설치**

프로젝트 루트 디렉토리에서 다음 명령어를 실행하여 필요한 모든 Flutter 패키지 및 의존성을 설치합니다.

`flutter pub get`

**🔑 API 및 서비스 설정**

**1. Naver Developer Center (지역 검색 API)**

- 네이버 개발자 센터에 접속하여 새로운 애플리케이션을 등록합니다.
- 검색 API를 활성화하고, **Client ID**와 **Client Secret**을 발급받습니다.
- 발급받은 키를 lib/data/repository/location_repository.dart 파일 내 LocationRepository 클래스의 HTTP 헤더에 설정합니다.

```dart
// lib/data/repository/location_repository.dart
options: Options(headers: {
  'X-Naver-Client-Id': 'YOUR_NAVER_CLIENT_ID',       // <-- 여기에 발급받은 Client ID 입력
  'X-Naver-Client-Secret': 'YOUR_NAVER_CLIENT_SECRET', // <-- 여기에 발급받은 Client Secret 입력
}),
```
⚠️ **401 Unauthorized 에러**는 대부분 이 키 설정 문제로 발생합니다.

**2. Firebase Project (Firestore Database)**

- Firebase Console에 접속하여 새로운 Firebase 프로젝트를 생성하거나 기존 프로젝트를 선택합니다.
- 생성한 프로젝트에 Flutter 앱을 등록하고, 플랫폼에 맞는 설정 파일(google-services.json for Android, GoogleService-Info.plist for iOS)을 다운로드하여 프로젝트의 해당 플랫폼 디렉토리(android/app/, ios/Runner/)에 추가합니다.
- Firestore Database 보안 규칙 설정:
- Firebase Console에서 Firestore Database 섹션으로 이동합니다.
- 규칙 (Rules) 탭을 선택합니다.
- 개발 및 테스트 목적으로 모든 사용자에게 읽기/쓰기 권한을 허용하는 다음 규칙을 적용한 후 게시 (Publish) 버튼을 클릭합니다.


```dart
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true; // ⚠️ 개발/테스트 전용! 실제 서비스에서는 반드시 보안 강화 필요
    }
  }
}
```
⚠️ **permission-denied 에러**는 이 보안 규칙 문제로 인해 발생합니다.
<br>

**▶️ 앱 실행**
모든 설정이 완료되면, 프로젝트 루트 디렉토리에서 다음 명령어를 실행하여 Flutter 앱을 빌드하고 기기/시뮬레이터에서 실행합니다.


`flutter run`