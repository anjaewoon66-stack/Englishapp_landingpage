# iOS 앱 Firebase App Distribution 배포 가이드

## 📱 프로젝트 정보
- **Bundle ID**: `com.example.englishappFlutter`
- **앱 이름**: Englishapp Flutter
- **현재 버전**: 1.0.0+1
- **Xcode**: 26.1.1 (설치 확인됨 ✅)
- **GoogleService-Info.plist**: 설정됨 ✅

---

## 📋 목차
1. [사전 요구사항](#사전-요구사항)
2. [Apple Developer 계정 설정](#apple-developer-계정-설정)
3. [Xcode 프로젝트 설정](#xcode-프로젝트-설정)
4. [iOS 앱 빌드](#ios-앱-빌드)
5. [Firebase App Distribution 배포](#firebase-app-distribution-배포)
6. [문제 해결](#문제-해결)

---

## 🔧 사전 요구사항

### 1. 필수 소프트웨어
- ✅ **macOS** (iOS 빌드는 Mac에서만 가능)
- ✅ **Xcode 26.1.1** (설치됨)
- ✅ **Flutter SDK**
- ✅ **Firebase CLI** (설치됨)

### 2. Apple Developer 계정

iOS 앱을 배포하려면 다음 중 하나가 필요합니다:

#### 옵션 A: Apple Developer Program (유료)
- **비용**: 연간 $99 (약 13만원)
- **장점**:
  - App Store 배포 가능
  - TestFlight 사용 가능
  - 모든 기능 사용 가능
- **등록**: https://developer.apple.com/programs/

#### 옵션 B: 무료 Apple ID (개발 테스트용)
- **비용**: 무료
- **장점**:
  - 로컬 디바이스 테스트 가능
  - Firebase App Distribution 사용 가능 (제한적)
- **제한**:
  - 7일 후 재서명 필요
  - 최대 3개 디바이스
  - App Store 배포 불가

---

## 👤 Apple Developer 계정 설정

### Step 1: Apple ID로 Xcode 로그인

1. **Xcode 열기**
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Xcode > Settings (⌘,)**

3. **Accounts 탭**
   - 왼쪽 하단 "+" 버튼 클릭
   - "Apple ID" 선택
   - Apple ID와 비밀번호 입력

4. **Team 확인**
   - Personal Team (무료) 또는
   - 유료 Developer Team

### Step 2: 인증서 관리 (자동)

Xcode가 자동으로 처리하므로 별도 작업 불필요합니다.

---

## 🛠 Xcode 프로젝트 설정

### Step 1: Xcode에서 프로젝트 열기

```bash
# 프로젝트 루트에서 실행
open ios/Runner.xcworkspace
```

⚠️ **중요**: `.xcodeproj`가 아닌 `.xcworkspace`를 열어야 합니다!

### Step 2: Signing & Capabilities 설정

1. **왼쪽 프로젝트 네비게이터에서 "Runner" 선택**

2. **TARGETS > Runner 선택**

3. **"Signing & Capabilities" 탭**

4. **Automatically manage signing 체크**
   - ✅ 자동으로 인증서와 프로비저닝 프로파일 관리

5. **Team 선택**
   - 드롭다운에서 Apple ID Team 선택
   - Personal Team 또는 유료 Developer Team

6. **Bundle Identifier 확인**
   - 현재: `com.example.englishappFlutter`
   - 필요시 변경 (예: `com.yourcompany.englishapp`)

### Step 3: Bundle Identifier 변경 (선택사항)

**왜 변경이 필요한가?**
- `com.example.*`은 테스트용이므로 프로덕션에서는 변경 권장
- 고유한 Bundle ID 필요

**변경 방법:**

1. **Xcode에서:**
   - Signing & Capabilities > Bundle Identifier 변경

2. **또는 직접 편집:**
   ```bash
   # ios/Runner.xcodeproj/project.pbxproj 파일에서
   # PRODUCT_BUNDLE_IDENTIFIER 검색 후 변경
   ```

3. **Firebase Console에서도 동일하게 업데이트:**
   - Firebase Console > 프로젝트 설정 > iOS 앱
   - Bundle ID 확인/업데이트

### Step 4: Deployment Target 확인

1. **General 탭**
2. **Deployment Info > iOS**
3. **최소 버전 확인** (현재 Podfile: iOS 13.0)

---

## 📦 iOS 앱 빌드

### 방법 1: Flutter CLI로 빌드 (권장)

#### A. Ad-hoc 배포용 빌드 (Firebase App Distribution)

```bash
# 1. 클린 빌드
flutter clean

# 2. 의존성 설치
flutter pub get

# 3. iOS 의존성 설치
cd ios && pod install && cd ..

# 4. IPA 빌드 (ad-hoc)
flutter build ipa --release --export-options-plist=ios/ExportOptions.plist
```

#### B. ExportOptions.plist 생성

Firebase App Distribution용 Export 옵션 파일을 생성해야 합니다:

**파일 위치**: `ios/ExportOptions.plist`

**내용**:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>ad-hoc</string>
    <key>teamID</key>
    <string>YOUR_TEAM_ID</string>
    <key>compileBitcode</key>
    <false/>
    <key>uploadSymbols</key>
    <true/>
    <key>signingStyle</key>
    <string>automatic</string>
</dict>
</plist>
```

**YOUR_TEAM_ID 찾는 방법:**
1. Xcode > Settings > Accounts
2. Team 선택 후 "View Details"
3. Team ID 복사

**또는 간단한 빌드 (ExportOptions 없이):**
```bash
flutter build ipa --release
```

이 경우 빌드 후 Xcode에서 수동으로 Export해야 합니다.

### 방법 2: Xcode에서 Archive (수동)

1. **Xcode에서 프로젝트 열기**
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Product > Scheme > Runner 선택**

3. **Product > Destination > Any iOS Device 선택**

4. **Product > Archive**
   - 빌드가 완료되면 Organizer 창이 열립니다

5. **Organizer에서 "Distribute App"**
   - "Ad Hoc" 선택
   - "Next"
   - "Automatically manage signing" 선택
   - "Export" 클릭

6. **IPA 파일 저장**
   - 저장 위치 선택
   - IPA 파일 생성됨

### 빌드 결과

**Flutter CLI 빌드:**
- 파일 위치: `build/ios/ipa/englishapp_flutter.ipa`

**Xcode Archive:**
- 선택한 위치에 IPA 파일 생성

---

## 🚀 Firebase App Distribution 배포

### 방법 1: Firebase CLI로 배포 (권장)

#### Step 1: Firebase 로그인

```bash
firebase login
```

#### Step 2: Firebase 앱 ID 확인

```bash
firebase apps:list
```

iOS 앱의 **App ID**를 복사하세요. 형식: `1:123456789:ios:abcdef...`

#### Step 3: 배포

```bash
firebase appdistribution:distribute \
  build/ios/ipa/englishapp_flutter.ipa \
  --app YOUR_IOS_APP_ID \
  --groups "testers" \
  --release-notes "iOS 베타 릴리스 v1.0.0 - 영어 학습 앱"
```

**예시:**
```bash
firebase appdistribution:distribute \
  build/ios/ipa/englishapp_flutter.ipa \
  --app 1:123456789:ios:abcdef123456 \
  --groups "qa-team" \
  --release-notes "첫 번째 iOS 베타 릴리스

새로운 기능:
- 단어 학습 모드
- 문법 퀴즈
- 학습 진도 추적"
```

### 방법 2: Firebase Console에서 수동 업로드

1. **Firebase Console 접속**
   - https://console.firebase.google.com

2. **프로젝트 선택**

3. **App Distribution**
   - 왼쪽 메뉴: "출시 및 모니터링" > "App Distribution"

4. **"배포 시작" 클릭**

5. **iOS 앱 선택**

6. **IPA 파일 드래그 앤 드롭**
   - `build/ios/ipa/englishapp_flutter.ipa`

7. **릴리스 노트 작성**

8. **테스터 그룹 선택**

9. **"배포" 클릭**

### 자동화 스크립트 사용

```bash
# iOS 빌드 및 배포 준비
./scripts/deploy_ios.sh
```

스크립트는 빌드만 수행하므로, 빌드 후 Firebase CLI 명령어로 배포하세요.

---

## 👥 테스터 관리

### iOS 테스터 추가 방법

1. **Firebase Console > App Distribution > 테스터 및 그룹**

2. **테스터 추가**
   - 이메일 주소 입력
   - 또는 그룹 생성

3. **테스터에게 초대 이메일 발송됨**

### 테스터가 앱을 설치하는 방법

#### 옵션 1: Firebase App Distribution 앱 사용

1. **App Store에서 "Firebase App Distribution" 설치**

2. **초대 이메일의 링크 클릭**

3. **Firebase App Distribution 앱이 열림**

4. **"다운로드" 및 "설치"**

#### 옵션 2: 웹 브라우저로 설치

1. **iOS 디바이스에서 초대 이메일 열기**

2. **"테스트 시작" 링크 클릭**

3. **Safari에서 프로파일 다운로드**

4. **설정 > 프로파일 다운로드됨 > 설치**

5. **앱 설치 완료**

⚠️ **중요**: iOS는 신뢰할 수 있는 개발자 인증이 필요합니다.
- 설정 > 일반 > VPN 및 디바이스 관리
- 개발자 앱 신뢰 필요

---

## ⚙️ 고급 설정

### 1. 버전 관리

**pubspec.yaml**에서 버전 관리:
```yaml
version: 1.0.0+1
#        ^^^^^ ^^
#        |     빌드 번호 (CFBundleVersion)
#        버전 이름 (CFBundleShortVersionString)
```

**업데이트 시:**
```yaml
version: 1.0.1+2  # 버전 1.0.1, 빌드 2
```

### 2. Firebase App ID를 환경 변수로 설정

```bash
# ~/.zshrc 또는 ~/.bash_profile에 추가
export FIREBASE_IOS_APP_ID="1:123456789:ios:abcdef123456"

# 배포 시
firebase appdistribution:distribute \
  build/ios/ipa/englishapp_flutter.ipa \
  --app $FIREBASE_IOS_APP_ID \
  --groups "testers" \
  --release-notes "릴리스 노트"
```

### 3. 자동 배포 스크립트 (완전 자동화)

**파일**: `scripts/deploy_ios_auto.sh`

```bash
#!/bin/bash

set -e

# 설정
FIREBASE_IOS_APP_ID="YOUR_IOS_APP_ID"
TESTER_GROUP="testers"
VERSION=$(grep "version:" pubspec.yaml | sed 's/version: //')

echo "🔨 iOS 앱 빌드 중... (v$VERSION)"
flutter clean
flutter pub get
cd ios && pod install && cd ..
flutter build ipa --release

echo ""
echo "📤 Firebase App Distribution에 배포 중..."
firebase appdistribution:distribute \
  build/ios/ipa/englishapp_flutter.ipa \
  --app $FIREBASE_IOS_APP_ID \
  --groups "$TESTER_GROUP" \
  --release-notes "iOS v$VERSION 배포"

echo ""
echo "✅ 배포 완료!"
```

---

## 🐛 문제 해결

### 문제 1: "Signing for 'Runner' requires a development team"

**원인**: Xcode에서 Team이 선택되지 않음

**해결:**
1. Xcode 열기: `open ios/Runner.xcworkspace`
2. Runner 프로젝트 선택
3. Signing & Capabilities 탭
4. Team 선택

### 문제 2: "Provisioning profile doesn't include signing certificate"

**원인**: 인증서 문제

**해결:**
```bash
# 1. Xcode에서 Automatically manage signing 체크
# 2. Xcode > Settings > Accounts > Download Manual Profiles
# 3. 또는 인증서 재생성
```

### 문제 3: Flutter 빌드 실패 "Pod install failed"

**원인**: CocoaPods 의존성 문제

**해결:**
```bash
# CocoaPods 캐시 정리
cd ios
pod deintegrate
pod cache clean --all
rm Podfile.lock
pod install
cd ..

# Flutter 재빌드
flutter clean
flutter pub get
flutter build ipa --release
```

### 문제 4: "No devices found"

**원인**: iOS 시뮬레이터/디바이스 없음

**해결:**
```bash
# iOS 시뮬레이터 실행
open -a Simulator

# 또는 Xcode에서 "Any iOS Device" 선택
```

### 문제 5: Firebase CLI 인증 오류

**해결:**
```bash
firebase logout
firebase login
```

### 문제 6: IPA 파일이 생성되지 않음

**확인 사항:**
```bash
# 빌드 로그 확인
flutter build ipa --release --verbose

# 빌드 디렉토리 확인
ls -la build/ios/archive/
ls -la build/ios/ipa/
```

### 문제 7: "App installation failed" (테스터 측)

**원인**: 디바이스가 프로비저닝 프로파일에 포함되지 않음

**해결:**
1. Ad-hoc 배포는 등록된 디바이스만 설치 가능
2. 디바이스 UDID를 Apple Developer에 등록
3. 또는 Development 빌드로 변경

---

## 📝 체크리스트

배포 전 확인사항:

### 사전 준비
- [ ] macOS 및 Xcode 설치 확인
- [ ] Apple ID 준비 (무료 또는 유료)
- [ ] Firebase CLI 로그인 (`firebase login`)
- [ ] GoogleService-Info.plist 확인 (`ios/GoogleService-Info.plist`)

### Xcode 설정
- [ ] Xcode에서 프로젝트 열기 (`open ios/Runner.xcworkspace`)
- [ ] Apple ID로 로그인 (Xcode > Settings > Accounts)
- [ ] Team 선택 (Signing & Capabilities)
- [ ] Bundle Identifier 확인/변경
- [ ] Automatically manage signing 활성화

### 빌드
- [ ] Flutter 의존성 설치 (`flutter pub get`)
- [ ] iOS 의존성 설치 (`cd ios && pod install`)
- [ ] IPA 빌드 (`flutter build ipa --release`)
- [ ] 빌드 성공 확인 (`ls build/ios/ipa/englishapp_flutter.ipa`)

### Firebase 배포
- [ ] Firebase 앱 ID 확인 (`firebase apps:list`)
- [ ] 테스터 그룹 생성 (Firebase Console)
- [ ] Firebase App Distribution 활성화
- [ ] 앱 배포 (CLI 또는 Console)

### 테스터 확인
- [ ] 테스터 초대 이메일 발송 확인
- [ ] 테스터 앱 설치 및 테스트

---

## 🎯 빠른 시작 가이드

처음 배포하는 경우 다음 순서로 진행하세요:

```bash
# 1. Xcode에서 프로젝트 열고 Team 설정
open ios/Runner.xcworkspace

# (Xcode에서 Signing & Capabilities > Team 선택)

# 2. Firebase 로그인
firebase login

# 3. Firebase 앱 ID 확인
firebase apps:list

# 4. iOS 빌드
flutter clean
flutter pub get
cd ios && pod install && cd ..
flutter build ipa --release

# 5. Firebase에 배포
firebase appdistribution:distribute \
  build/ios/ipa/englishapp_flutter.ipa \
  --app YOUR_IOS_APP_ID \
  --groups "testers" \
  --release-notes "첫 번째 iOS 베타 릴리스"
```

---

## 📚 추가 리소스

- [Apple Developer Documentation](https://developer.apple.com/documentation/)
- [Firebase App Distribution iOS 가이드](https://firebase.google.com/docs/app-distribution/ios/distribute-console)
- [Flutter iOS 배포 가이드](https://docs.flutter.dev/deployment/ios)
- [Xcode 코드 서명 가이드](https://developer.apple.com/support/code-signing/)

---

**작성일**: 2024년 12월 24일
**Bundle ID**: `com.example.englishappFlutter`
**Xcode 버전**: 26.1.1
