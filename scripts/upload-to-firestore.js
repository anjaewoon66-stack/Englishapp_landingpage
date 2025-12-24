const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');

// Firebase Admin SDK 초기화
// 먼저 Firebase Console에서 서비스 계정 키를 다운로드해야 합니다
// Firebase Console > 프로젝트 설정 > 서비스 계정 > 새 비공개 키 생성

// GoogleService-Info.plist에서 프로젝트 정보 가져오기
const projectId = "english-learning-app-19e72";

admin.initializeApp({
  credential: admin.credential.applicationDefault(),
  projectId: projectId
});

const db = admin.firestore();

async function uploadData() {
  try {
    console.log('🚀 Starting data upload to Firestore...\n');

    // 단어 데이터 업로드
    await uploadVocabulary();

    // 문법 데이터 업로드
    await uploadGrammar();

    console.log('\n✅ All data uploaded successfully!');
    process.exit(0);
  } catch (error) {
    console.error('❌ Error uploading data:', error);
    process.exit(1);
  }
}

async function uploadVocabulary() {
  console.log('📚 Uploading vocabulary data...');

  const vocabularyPath = path.join(__dirname, '../assets/data/default_vocabulary.json');
  const vocabularyData = JSON.parse(fs.readFileSync(vocabularyPath, 'utf8'));

  const batch = db.batch();
  let count = 0;

  for (const item of vocabularyData) {
    const docRef = db.collection('default_vocabulary').doc(item.id);
    batch.set(docRef, {
      ...item,
      createdAt: admin.firestore.Timestamp.fromDate(new Date(item.createdAt)),
      lastReviewedAt: item.lastReviewedAt
        ? admin.firestore.Timestamp.fromDate(new Date(item.lastReviewedAt))
        : null
    });
    count++;
  }

  await batch.commit();
  console.log(`   ✓ Uploaded ${count} vocabulary items`);

  // 카테고리별 개수 출력
  const categoryCounts = vocabularyData.reduce((acc, item) => {
    acc[item.category] = (acc[item.category] || 0) + 1;
    return acc;
  }, {});

  console.log('   📊 By category:');
  Object.entries(categoryCounts).forEach(([category, count]) => {
    console.log(`      - ${category}: ${count} items`);
  });
}

async function uploadGrammar() {
  console.log('\n📖 Uploading grammar data...');

  const grammarPath = path.join(__dirname, '../assets/data/default_grammar.json');
  const grammarData = JSON.parse(fs.readFileSync(grammarPath, 'utf8'));

  const batch = db.batch();
  let count = 0;

  for (const item of grammarData) {
    const docRef = db.collection('default_grammar').doc(item.id);
    batch.set(docRef, {
      ...item,
      createdAt: admin.firestore.Timestamp.fromDate(new Date(item.createdAt))
    });
    count++;
  }

  await batch.commit();
  console.log(`   ✓ Uploaded ${count} grammar items`);

  // 레벨별 개수 출력
  const levelCounts = grammarData.reduce((acc, item) => {
    acc[item.level] = (acc[item.level] || 0) + 1;
    return acc;
  }, {});

  console.log('   📊 By level:');
  Object.entries(levelCounts).forEach(([level, count]) => {
    console.log(`      - ${level}: ${count} items`);
  });
}

// 스크립트 실행
uploadData();
