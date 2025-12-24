#!/bin/bash

# iOS Firebase App Distribution 자동 배포 스크립트
# 사용법: ./scripts/deploy_ios_auto.sh

set -e

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 설정 확인
echo -e "${BLUE}🔍 설정 확인 중...${NC}"

if [ -z "$FIREBASE_IOS_APP_ID" ]; then
    echo -e "${RED}❌ FIREBASE_IOS_APP_ID 환경 변수가 설정되지 않았습니다.${NC}"
    echo ""
    echo "Firebase iOS App ID를 설정하려면:"
    echo "1. firebase apps:list 명령어로 App ID 확인"
    echo "2. 다음 명령어 실행:"
    echo "   export FIREBASE_IOS_APP_ID=\"1:123456789:ios:abcdef123456\""
    echo ""
    echo "또는 ~/.zshrc 또는 ~/.bash_profile에 추가:"
    echo "   echo 'export FIREBASE_IOS_APP_ID=\"YOUR_APP_ID\"' >> ~/.zshrc"
    echo ""
    exit 1
fi

# 테스터 그룹 (기본값: testers)
TESTER_GROUP="${FIREBASE_TESTER_GROUP:-testers}"

# 버전 정보 가져오기
VERSION=$(grep "version:" pubspec.yaml | sed 's/version: //' | xargs)

echo -e "${GREEN}✅ 설정 확인 완료${NC}"
echo "  - App ID: $FIREBASE_IOS_APP_ID"
echo "  - 테스터 그룹: $TESTER_GROUP"
echo "  - 버전: $VERSION"
echo ""

# 릴리스 노트 입력
echo -e "${YELLOW}📝 릴리스 노트를 입력하세요 (엔터로 기본값 사용):${NC}"
read -p "릴리스 노트: " RELEASE_NOTES

if [ -z "$RELEASE_NOTES" ]; then
    RELEASE_NOTES="iOS v$VERSION 배포"
fi

echo ""
echo -e "${BLUE}🔨 iOS 앱 빌드 중... (v$VERSION)${NC}"

# Clean 빌드
echo "  → flutter clean"
flutter clean > /dev/null 2>&1

# 의존성 설치
echo "  → flutter pub get"
flutter pub get > /dev/null 2>&1

# iOS 의존성 설치
echo "  → pod install"
cd ios
pod install > /dev/null 2>&1
cd ..

# IPA 빌드
echo "  → flutter build ipa --release"
flutter build ipa --release

echo ""
echo -e "${GREEN}✅ 빌드 완료!${NC}"

# IPA 파일 확인
IPA_PATH="build/ios/ipa/englishapp_flutter.ipa"
if [ ! -f "$IPA_PATH" ]; then
    echo -e "${RED}❌ IPA 파일을 찾을 수 없습니다: $IPA_PATH${NC}"
    exit 1
fi

# 파일 크기 확인
IPA_SIZE=$(du -h "$IPA_PATH" | cut -f1)
echo "  📦 IPA 파일: $IPA_PATH ($IPA_SIZE)"

echo ""
echo -e "${BLUE}📤 Firebase App Distribution에 배포 중...${NC}"

# Firebase 배포
firebase appdistribution:distribute \
  "$IPA_PATH" \
  --app "$FIREBASE_IOS_APP_ID" \
  --groups "$TESTER_GROUP" \
  --release-notes "$RELEASE_NOTES"

echo ""
echo -e "${GREEN}✅ 배포 완료!${NC}"
echo ""
echo -e "${YELLOW}📱 테스터들이 Firebase App Distribution 앱에서 업데이트를 확인할 수 있습니다.${NC}"
