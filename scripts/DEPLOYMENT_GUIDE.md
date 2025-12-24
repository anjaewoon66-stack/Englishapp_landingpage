# Firebase App Distribution 배포 가이드

## 📋 목차
1. [사전 준비](#사전-준비)
2. [앱 빌드](#앱-빌드)
3. [Firebase 설정](#firebase-설정)
4. [테스터 관리](#테스터-관리)
5. [앱 배포](#앱-배포)

---

## 🔧 사전 준비

### 1. Android google-services.json 다운로드 (필수)

현재 **Android google-services.json 파일이 없습니다.** 다음 단계를 따라 다운로드하세요:

1. [Firebase Console](https://console.firebase.google.com) 접속
2. 프로젝트 선택
3. 프로젝트 설정 (⚙️ 아이콘) > 일반 탭
4. "내 앱" 섹션에서 Android 앱 찾기
   - Android 앱이 없다면: "앱 추가" > Android 선택
   - 패키지 이름: `com.example.englishapp_flutter`
5. `google-services.json` 다운로드
6. **파일을 `android/app/` 디렉토리에 복사**

```bash
# 파일 위치 확인
ls android/app/google-services.json
```

### 2. Firebase CLI 로그인

```bash
# Firebase 로그인
firebase login

# 프로젝트 목록 확인
firebase projects:list

# 앱 목록 확인 (App ID 필요)
firebase apps:list
```

---

## 📦 앱 빌드

### Android APK 빌드

#### 방법 1: 스크립트 사용 (권장)
```bash
./scripts/deploy_android.sh
```

#### 방법 2: 직접 빌드
```bash
flutter clean
flutter pub get
flutter build apk --release
```

**빌드 결과:**
- 파일: `build/app/outputs/flutter-apk/app-release.apk`
- 크기: 약 20-40MB

### iOS IPA 빌드 (Mac 전용)

#### 방법 1: 스크립트 사용
```bash
./scripts/deploy_ios.sh
```

#### 방법 2: 직접 빌드
```bash
flutter clean
flutter pub get
flutter build ipa --release
```

**빌드 결과:**
- 파일: `build/ios/ipa/englishapp_flutter.ipa`

**⚠️ iOS 빌드 요구사항:**
- Mac 컴퓨터
- Xcode 설치
- Apple Developer 계정
- 코드 서명 인증서

---

## 🌐 Firebase 설정

### 1. Firebase Console에서 App Distribution 활성화

1. [Firebase Console](https://console.firebase.google.com) 접속
2. 프로젝트 선택
3. 왼쪽 메뉴: **출시 및 모니터링 > App Distribution**
4. "시작하기" 클릭

### 2. Firebase 프로젝트 초기화 (선택사항)

```bash
# 프로젝트 루트에서 실행
firebase init

# 선택 항목:
# ◯ App Distribution (스페이스바로 선택)
# ◯ 기존 프로젝트 선택
# ◯ App ID 선택/입력
```

---

## 👥 테스터 관리

### Firebase Console에서 테스터 추가

1. Firebase Console > App Distribution
2. **"테스터 및 그룹"** 탭
3. 테스터 추가 방법:

#### 개별 테스터 추가
- "테스터 추가" 버튼
- 이메일 주소 입력 (여러 개는 쉼표로 구분)
- 예: `tester1@gmail.com, tester2@gmail.com`

#### 그룹 생성 (권장)
- "그룹 만들기" 클릭
- 그룹 이름 입력 (예: "QA", "베타테스터", "내부팀")
- 테스터 이메일 추가
- 나중에 배포 시 그룹명으로 쉽게 지정 가능

---

## 🚀 앱 배포

### 방법 1: Firebase CLI로 배포 (권장)

#### Android 배포
```bash
# 1. 앱 빌드
flutter build apk --release

# 2. App ID 확인
firebase apps:list

# 3. 배포 (YOUR_ANDROID_APP_ID 교체)
firebase appdistribution:distribute \
  build/app/outputs/flutter-apk/app-release.apk \
  --app YOUR_ANDROID_APP_ID \
  --groups "testers" \
  --release-notes "첫 번째 베타 릴리스 - 영어 학습 앱 v1.0.0"
```

#### iOS 배포
```bash
# 1. 앱 빌드
flutter build ipa --release

# 2. App ID 확인
firebase apps:list

# 3. 배포 (YOUR_IOS_APP_ID 교체)
firebase appdistribution:distribute \
  build/ios/ipa/englishapp_flutter.ipa \
  --app YOUR_IOS_APP_ID \
  --groups "testers" \
  --release-notes "첫 번째 베타 릴리스 - 영어 학습 앱 v1.0.0"
```

### 방법 2: Firebase Console에서 수동 업로드

1. Firebase Console > App Distribution
2. **"릴리스"** 탭
3. "배포 시작" 버튼
4. APK 또는 IPA 파일 **드래그 앤 드롭**
5. **릴리스 노트** 작성
   ```
   v1.0.0 - 2024년 12월

   새로운 기능:
   - 단어 학습 기능
   - 문법 학습 기능
   - 학습 진도 추적
   - Firebase 연동
   ```
6. **테스터 그룹** 선택
7. "배포" 클릭

---

## 📱 테스터가 앱을 받는 방법

### 1. 초대 이메일 확인
테스터는 등록한 이메일로 초대를 받습니다.

### 2. Firebase App Distribution 앱 설치

**Android:**
- Google Play에서 "Firebase App Distribution" 검색 및 설치
- 또는 초대 이메일의 링크 클릭

**iOS:**
- App Store에서 "Firebase App Distribution" 검색 및 설치
- 또는 TestFlight 사용

### 3. 앱 다운로드 및 설치
- Firebase App Distribution 앱 열기
- 초대된 앱 목록에서 선택
- "다운로드" 및 "설치"

---

## 🔄 업데이트 배포

새 버전을 배포할 때:

1. `pubspec.yaml`에서 버전 업데이트
   ```yaml
   version: 1.0.1+2  # 1.0.1은 버전명, 2는 빌드 번호
   ```

2. 앱 재빌드 및 배포
   ```bash
   flutter build apk --release

   firebase appdistribution:distribute \
     build/app/outputs/flutter-apk/app-release.apk \
     --app YOUR_APP_ID \
     --groups "testers" \
     --release-notes "v1.0.1 - 버그 수정 및 성능 개선"
   ```

3. 테스터들은 자동으로 업데이트 알림을 받습니다.

---

## 💡 유용한 팁

### 릴리스 노트 작성 예시
```
v1.0.0 - 2024년 12월 24일

✨ 새로운 기능
- 단어 학습 모드 추가
- 문법 퀴즈 기능

🐛 버그 수정
- 로그인 오류 수정
- 데이터 동기화 개선

🚀 성능 개선
- 앱 시작 속도 향상
- 메모리 사용량 최적화
```

### 테스터 그룹 전략
- **internal**: 내부 개발팀
- **qa**: QA 테스터
- **beta**: 베타 테스터
- **all**: 모든 테스터

### 자동화 스크립트 활용
```bash
# 빌드부터 배포까지 한 번에
./scripts/deploy_android.sh
firebase appdistribution:distribute \
  build/app/outputs/flutter-apk/app-release.apk \
  --app YOUR_APP_ID \
  --groups "beta" \
  --release-notes "자동 배포 테스트"
```

---

## ❓ 문제 해결

### Firebase CLI 인증 오류
```bash
firebase logout
firebase login
```

### APK 빌드 실패
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter build apk --release
```

### iOS 서명 오류
Xcode에서 프로젝트 열기:
```bash
open ios/Runner.xcworkspace
```
- Signing & Capabilities 탭에서 개발팀 선택
- Provisioning Profile 확인

---

## 📚 참고 자료

- [Firebase App Distribution 문서](https://firebase.google.com/docs/app-distribution)
- [Flutter 빌드 가이드](https://docs.flutter.dev/deployment)
- [Firebase CLI 문서](https://firebase.google.com/docs/cli)

---

**작성일:** 2024년 12월 24일
**앱 버전:** 1.0.0
