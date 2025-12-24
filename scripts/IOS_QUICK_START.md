# iOS 배포 빠른 시작 가이드 🚀

## 5분 안에 iOS 앱 배포하기

### 📋 사전 체크리스트

- [ ] Mac 컴퓨터 사용 중
- [ ] Xcode 설치됨 (확인: `xcodebuild -version`)
- [ ] Apple ID 준비됨
- [ ] Firebase 프로젝트 생성됨

---

## 🎯 단계별 가이드

### 1단계: Xcode 설정 (5분)

```bash
# 1. Xcode 프로젝트 열기
open ios/Runner.xcworkspace
```

**Xcode에서:**
1. 왼쪽 파일 목록에서 **"Runner"** (파란색 아이콘) 클릭
2. **TARGETS > Runner** 선택
3. **"Signing & Capabilities"** 탭 클릭
4. **"Automatically manage signing"** 체크박스 활성화
5. **Team** 드롭다운에서 Apple ID 선택
   - 없으면: **Xcode > Settings > Accounts**에서 Apple ID 추가

✅ Team 선택되면 완료!

---

### 2단계: Firebase 설정 (2분)

```bash
# 1. Firebase 로그인
firebase login

# 2. iOS App ID 확인 및 복사
firebase apps:list
```

**iOS App ID 예시**: `1:123456789:ios:abcdef123456`

이 ID를 복사해두세요!

---

### 3단계: 환경 변수 설정 (1분)

```bash
# Firebase iOS App ID 설정
export FIREBASE_IOS_APP_ID="여기에_복사한_APP_ID_붙여넣기"

# 예시:
# export FIREBASE_IOS_APP_ID="1:123456789:ios:abcdef123456"
```

**영구적으로 설정하려면:**
```bash
echo 'export FIREBASE_IOS_APP_ID="YOUR_APP_ID"' >> ~/.zshrc
source ~/.zshrc
```

---

### 4단계: 빌드 및 배포 (10-15분)

#### 옵션 A: 자동 스크립트 (권장)

```bash
./scripts/deploy_ios_auto.sh
```

#### 옵션 B: 수동 실행

```bash
# 1. 클린 빌드
flutter clean
flutter pub get

# 2. iOS 의존성 설치
cd ios && pod install && cd ..

# 3. IPA 빌드
flutter build ipa --release

# 4. Firebase 배포
firebase appdistribution:distribute \
  build/ios/ipa/englishapp_flutter.ipa \
  --app $FIREBASE_IOS_APP_ID \
  --groups "testers" \
  --release-notes "첫 번째 iOS 베타 릴리스"
```

---

### 5단계: 테스터 추가

**Firebase Console에서:**
1. https://console.firebase.google.com
2. 프로젝트 선택
3. **App Distribution** > **테스터 및 그룹**
4. **"테스터 추가"** 버튼
5. 이메일 입력 후 초대

---

## ✅ 완료!

테스터들이 이메일로 초대를 받고 앱을 설치할 수 있습니다.

---

## 🐛 문제 발생 시

### "No Team found"
→ Xcode > Settings > Accounts에서 Apple ID 추가

### "Pod install failed"
```bash
cd ios
pod deintegrate
pod install
cd ..
```

### "Signing error"
→ Xcode > Signing & Capabilities > Team 다시 선택

### 자세한 문제 해결
→ `scripts/IOS_DEPLOYMENT_GUIDE.md` 참조

---

## 📞 도움이 필요하신가요?

전체 가이드: [IOS_DEPLOYMENT_GUIDE.md](IOS_DEPLOYMENT_GUIDE.md)
