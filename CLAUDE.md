# 할두 (Haldo) - Flutter Web App

> 건강한 인생 2막, 할두와 함께해요!

## 📱 프로젝트 개요

할두는 할머니가 되어서도 두근두근한 삶을 응원하는 브랜드의 공식 웹 애플리케이션입니다. Flutter로 개발된 반응형 웹 애플리케이션으로, 모던하고 세련된 UI/UX를 제공합니다.

### 🎯 주요 기능
- **반응형 디자인**: 데스크톱/모바일 완벽 지원
- **갤러리 스와이프**: 폰 갤러리와 동일한 사용자 경험
- **인터랙티브 네비게이션**: 호버 효과와 부드러운 애니메이션
- **브랜드 중심 디자인**: 할두만의 독특한 색상과 타이포그래피

## 🏗️ 아키텍처

### 디렉토리 구조
```
lib/
├── main.dart                     # 앱 진입점
├── screens/
│   └── home_screen.dart         # 메인 홈 화면
└── widgets/
    ├── hero_section.dart        # 히어로 섹션 (갤러리)
    ├── app_bar_widget.dart      # 네비게이션 바
    ├── footer_section.dart      # 푸터
    ├── about_section.dart       # About 섹션
    ├── contents_section.dart    # Contents 섹션
    ├── shop_section.dart        # Shop 섹션
    └── advanced_swipe_gallery.dart  # 고급 스와이프 갤러리
```

### 🎨 주요 컴포넌트

#### 1. HeroSection (히어로 섹션)
- **위치**: `lib/widgets/hero_section.dart`
- **기능**:
  - 폰 갤러리와 동일한 드래그 스와이프
  - 페이드인/페이드아웃 전환 효과
  - 슬라이드별 다른 텍스트 표시
  - 자동 슬라이드 (4초 간격)
- **특징**:
  - 30° 각도 임계값으로 가로/세로 제스처 구분
  - 속도 기반 페이지 전환 (500px/s)
  - 부드러운 애니메이션 (800ms 페이드)

#### 2. AppBarWidget (네비게이션 바)
- **위치**: `lib/widgets/app_bar_widget.dart`
- **기능**:
  - 호버 시 텍스트 변경 (ABOUT → 할두란?, CONTENTS → 콘텐츠, SHOP → 쇼핑)
  - 투명/불투명 테마 지원
  - 반응형 모바일 메뉴
- **색상**: 호버 시 `#2ECC71` (브랜드 녹색)

#### 3. FooterSection (푸터)
- **위치**: `lib/widgets/footer_section.dart`
- **기능**:
  - 회사 정보 표시
  - 소셜 미디어 링크 (인스타그램, 카카오톡, 블로그, 카페)
  - 이용약관/개인정보처리방침 링크
- **디자인**: 브랜드 녹색 배경 (`#00C853`)

#### 4. AdvancedSwipeGallery (고급 갤러리)
- **위치**: `lib/widgets/advanced_swipe_gallery.dart`
- **기능**:
  - 터치/마우스 겸용 제스처
  - 관성 스와이프 (velocity 기반)
  - 스냅 동작 및 러버밴딩 효과
  - 키보드 네비게이션 (화살표 키)
  - 스크린리더 접근성 지원

## 🎨 디자인 시스템

### 색상 팔레트
- **브랜드 녹색**: `#00C853` / `#2ECC71`
- **배경**: 흰색 / 투명
- **텍스트**: 회색 계열 / 흰색
- **강조**: 핑크 계열 (`Colors.pink[600]`)

### 타이포그래피
- **브랜드 로고**: Inter 폰트, 굵기 900
- **한글 텍스트**: Noto Sans, 다양한 굵기
- **영문 네비게이션**: Noto Sans, 굵기 700

### 애니메이션
- **기본 전환**: 200ms `Curves.easeInOut`
- **페이드 효과**: 800ms `Curves.easeInOut`
- **드래그 응답**: 실시간 (60fps)

## 🛠️ 개발 환경

### 필수 패키지
```yaml
dependencies:
  flutter: ^3.0.0
  google_fonts: ^6.1.0
  url_launcher: ^6.2.0

dev_dependencies:
  flutter_lints: ^5.0.0
```

### 개발 명령어
```bash
# 패키지 설치
flutter pub get

# 개발 서버 실행
flutter run -d chrome

# 웹 빌드
flutter build web

# 코드 분석
flutter analyze

# 타입 체크
flutter analyze --fatal-infos
```

## 📝 개발 가이드라인

### 코드 스타일
- **상태 관리**: StatefulWidget 기반
- **애니메이션**: AnimationController + Tween
- **반응형**: MediaQuery.of(context).size.width 기반
- **접근성**: Semantics 위젯 적극 활용

### 성능 최적화
- `RepaintBoundary`로 불필요한 리페인트 방지
- `Transform` 기반 애니메이션으로 GPU 가속
- `AnimatedBuilder`로 필요한 부분만 리빌드
- 이미지 에러 핸들링 포함

### 반응형 기준점
- **데스크톱**: `width > 768px`
- **모바일**: `width <= 768px`
- **폰트 크기**: 데스크톱 기준 1.5배 확대

## 🚀 배포

### 웹 배포 준비
```bash
# 웹 빌드 (최적화)
flutter build web --release

# 빌드 파일 위치
build/web/
```

### 환경 설정
- **base href**: 도메인 루트 경로 설정
- **CORS**: 이미지 리소스 접근 권한
- **PWA**: 필요 시 웹 앱 매니페스트 설정

## 🔧 문제 해결

### 자주 발생하는 이슈

1. **이미지 로딩 실패**
   - `assets/images/` 경로 확인
   - `pubspec.yaml`에 assets 등록 확인

2. **제스처 충돌**
   - 30° 각도 임계값으로 해결됨
   - 수직 스크롤과 가로 드래그 구분

3. **애니메이션 끊김**
   - `TickerProviderStateMixin` 사용
   - `dispose()`에서 컨트롤러 정리

4. **반응형 레이아웃**
   - `MediaQuery` 기반 조건부 렌더링
   - `Flexible`/`Expanded` 위젯 활용

## 📞 연락처

- **회사**: (주)PJY Seoul Park
- **이메일**: team@haldo.kr
- **전화**: 010-9195-1452
- **주소**: 경남 창원시 성산구 가음정로 59

---

*이 문서는 할두 프로젝트의 개발 및 유지보수를 위한 가이드입니다. 추가 질문이나 개선사항이 있다면 개발팀에 문의해주세요.*