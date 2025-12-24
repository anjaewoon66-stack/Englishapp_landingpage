#!/bin/bash

# iOS App Distribution 배포 스크립트

set -e

echo "🔨 iOS IPA 빌드 중..."
flutter clean
flutter pub get
flutter build ipa --release

echo ""
echo "✅ IPA 빌드 완료!"
echo "📦 파일 위치: build/ios/ipa/englishapp_flutter.ipa"
echo ""
echo "📤 Firebase App Distribution에 배포하려면:"
echo ""
echo "firebase appdistribution:distribute \\"
echo "  build/ios/ipa/englishapp_flutter.ipa \\"
echo "  --app YOUR_IOS_APP_ID \\"
echo "  --groups \"testers\" \\"
echo "  --release-notes \"릴리스 노트를 여기에 작성하세요\""
echo ""
echo "💡 YOUR_IOS_APP_ID는 다음 명령어로 확인:"
echo "   firebase apps:list"
echo ""
echo "⚠️  주의: iOS 빌드는 Apple Developer 계정과 인증서가 필요합니다"
