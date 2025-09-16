# Firebase 설정 가이드

Flutter 웹앱에 Firebase Authentication이 성공적으로 구현되었습니다! 🎉

## 🔧 다음 단계: Firebase 프로젝트 설정

### 1. Firebase Console에서 프로젝트 생성
1. [Firebase Console](https://console.firebase.google.com/)에 접속
2. "프로젝트 추가" 클릭
3. 프로젝트 이름 입력 (예: `haldu-webapp`)
4. Google Analytics 설정 (선택사항)

### 2. 웹 앱 추가
1. Firebase 프로젝트에서 "웹" 아이콘 클릭
2. 앱 닉네임 입력 (예: `Haldu Web`)
3. Firebase Hosting 설정 체크 (선택사항)

### 3. 설정값 복사 및 적용

Firebase Console에서 제공되는 설정값을 다음 두 파일에 입력하세요:

#### A. `web/index.html` 파일의 firebaseConfig 객체:
```javascript
const firebaseConfig = {
  apiKey: "your-actual-api-key",
  authDomain: "your-project.firebaseapp.com", 
  projectId: "your-project-id",
  storageBucket: "your-project.appspot.com",
  messagingSenderId: "123456789",
  appId: "your-actual-app-id"
};
```

#### B. `lib/main.dart` 파일의 FirebaseOptions:
```dart
await Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: "your-actual-api-key",
    authDomain: "your-project.firebaseapp.com",
    projectId: "your-project-id", 
    storageBucket: "your-project.appspot.com",
    messagingSenderId: "123456789",
    appId: "your-actual-app-id",
  ),
);
```

### 4. Authentication 활성화
1. Firebase Console에서 "Authentication" 메뉴 클릭
2. "Sign-in method" 탭 선택
3. "이메일/비밀번호" 공급업체 활성화

## 🚀 패키지 설치 및 실행

```bash
# Firebase 패키지 설치
flutter pub get

# 웹으로 실행 (Chrome 권장)
flutter run -d chrome
```

## ✨ 구현된 기능들

### 🔐 인증 기능
- **회원가입**: 이메일/비밀번호로 새 계정 생성
- **로그인**: 기존 계정으로 로그인  
- **로그아웃**: 현재 세션 종료
- **비밀번호 찾기**: 이메일로 비밀번호 재설정 링크 전송
- **실시간 인증 상태 감지**: 자동으로 로그인/로그아웃 상태 업데이트

### 🛡️ 보안 기능
- Firebase의 강력한 보안 규칙 적용
- 클라이언트 사이드 유효성 검사
- 적절한 에러 메시지 표시 (한국어)

### 🎨 UI/UX
- 모던하고 직관적인 로그인/회원가입 다이얼로그
- 로딩 상태 표시
- 에러 메시지 스낵바
- 약관 동의 프로세스

## 🔍 추가 설정 옵션

### 소셜 로그인 추가 (선택사항)
Google, Facebook, GitHub 등의 소셜 로그인을 추가하고 싶다면:

1. Firebase Console에서 해당 공급업체 활성화
2. `AuthService`에 소셜 로그인 메서드 추가:

```dart
Future<bool> signInWithGoogle() async {
  // Google 로그인 구현
}
```

### 이메일 인증 (선택사항)
회원가입 후 이메일 인증을 요구하려면:

```dart
// 회원가입 후
await user.sendEmailVerification();
```

## 🐛 문제 해결

### 웹에서 CORS 오류 발생시
Firebase Console에서 승인된 도메인에 `localhost:port`를 추가하세요.

### 패키지 버전 충돌시  
```bash
flutter pub deps
flutter clean
flutter pub get
```

## 📱 추후 확장

이 Firebase 설정은 다음 플랫폼에서도 동일하게 작동합니다:
- iOS 앱 (추가 설정 필요)
- Android 앱 (추가 설정 필요)
- 데스크톱 앱

---

💡 **Tip**: Firebase Console에서 사용자 관리, 분석, 보안 규칙 등을 실시간으로 모니터링할 수 있습니다.