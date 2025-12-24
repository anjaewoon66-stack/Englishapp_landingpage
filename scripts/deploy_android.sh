#!/bin/bash

# Android App Distribution 배포 스크립트

set -e

echo "🔨 Android APK 빌드 중..."
flutter clean
flutter pub get
flutter build apk --release

echo ""
echo "✅ APK 빌드 완료!"
echo "📦 파일 위치: build/app/outputs/flutter-apk/app-release.apk"
echo ""
echo "📤 Firebase App Distribution에 배포하려면:"
echo ""
echo "firebase appdistribution:distribute \\"
echo "  build/app/outputs/flutter-apk/app-release.apk \\"
echo "  --app YOUR_ANDROID_APP_ID \\"
echo "  --groups \"testers\" \\"
echo "  --release-notes \"릴리스 노트를 여기에 작성하세요\""
echo ""
echo "💡 YOUR_ANDROID_APP_ID는 다음 명령어로 확인:"
echo "   firebase apps:list"
