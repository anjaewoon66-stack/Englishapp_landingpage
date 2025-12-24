# Firestore 데이터 업로드 스크립트

이 스크립트는 `assets/data/` 폴더의 JSON 파일들을 Firestore에 업로드합니다.

## 사용 방법

### 1. Firebase CLI 로그인

```bash
firebase login
```

브라우저가 열리면 Google 계정으로 로그인하세요.

### 2. 데이터 업로드 실행

```bash
cd scripts
npm run upload
```

또는

```bash
cd scripts
node upload-to-firestore.js
```

## 업로드되는 데이터

- **단어 (Vocabulary)**: 20개
  - Beginner: 9개
  - Intermediate: 6개
  - Advanced: 5개

- **문법 (Grammar)**: 12개
  - Beginner: 4개
  - Intermediate: 4개
  - Advanced: 4개

## Firestore 컬렉션 구조

```
/default_vocabulary/{vocab_id}
/default_grammar/{grammar_id}
```

## 문제 해결

### 인증 오류가 발생하는 경우

1. `firebase login` 다시 실행
2. 올바른 Google 계정으로 로그인했는지 확인
3. Firebase 프로젝트에 액세스 권한이 있는지 확인

### 네트워크 오류

- 인터넷 연결 확인
- 방화벽 설정 확인
