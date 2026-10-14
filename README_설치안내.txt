전단지 자동 제작·관리 웹시스템 V1.1 (관리자용 MVP)
=================================================

포함 파일
  index.html        웹화면
  style.css         UI 스타일
  app.js            로그인/저장/MC/미리보기/A4 PDF 출력
  setup.sql         데이터베이스 + RLS + 비공개 Storage 정책

1. Supabase에 기존 영업관리와 별도 새 프로젝트를 만듭니다.
2. Supabase SQL Editor에서 setup.sql 전체 실행.
3. Authentication > Users > Add user로 이메일/비밀번호 계정을 생성합니다.
4. 생성된 사용자의 UID를 복사한 후 다음 SQL을 실행합니다.
   insert into public.app_users(id,role,active)
   values ('여기에-사용자-UID','admin',true);
5. Supabase Project Settings > API에서 Project URL 및 publishable key(또는 anon key) 확인.
   절대 service_role, sb_secret_ 키를 웹 앱에 넣지 마세요.
6. GitHub에 새 Private 또는 Public 코드 저장소를 만들고
   index.html, style.css, app.js를 저장소 루트에 업로드합니다.
   GitHub Pages: Settings > Pages > Deploy from branch > main/(root).
   ※ GitHub Pages는 공개 정적 코드 배포용입니다. 비공개 원본 및 전화번호는
      Supabase로만 전송되며 저장소에 올리지 않습니다.
7. GitHub Pages URL 접속 -> Supabase Project URL + publishable key 입력 -> 로그인.
8. MC 등록 -> 전단지 원본 PDF(정확히 A4 세로 2페이지) 또는 앞/뒷면 PNG/JPG 등록.
9. 전단지 관리에서 MC 선택 -> 뒷면 연락처 위치를 드래그 또는 mm 입력으로 조정 -> 저장.
10. 전단지 출력에서 전단지/MC 선택 -> PDF 저장 또는 PDF 열어 인쇄.
    프린터 인쇄 옵션: A4, 100%/실제 크기, 양면, 긴 쪽 넘김.

검증 안내
- 이 패키지는 계정 접속 정보 없이 작성되었으므로 실제 Supabase 데이터 연결 및
  인쇄기 출력 검증은 배포 후 필요합니다.
- 외부 라이브러리를 CDN으로 가져오므로 실행 시 인터넷 연결이 필요합니다.
- 파일 PDF/이미지의 바탕 디자인은 AI로 변경하지 않습니다. PDF 원본은 PDF 페이지
  자체를 복사하고, 그 위에 MC 이름과 연락처 레이어(PNG)를 추가합니다.
- PDF 출력을 위한 한글 글자 영상은 사용 중인 브라우저의 한글 글꼴로 생성됩니다.
  환경에 따라 글꼴 모양이 다를 수 있으니 테스트 출력 확인이 필요합니다.
- 기존 전단지에 연락처가 이미 포함돼 있으면 원본 내용은 지우지 않습니다.
  담당자 없는 기본 원본을 준비하여 등록해야 합니다.
- PDF는 2페이지 A4 세로만 접수; 이미지 원본은 A4 비율이 다르면 비율 유지로
  페이지 안에 들어가며 여백이 생길 수 있습니다.
- 프로모션 기한 만료 시 경고를 표시하지만 출력 자체는 허용합니다.
- 1차에서는 관리자 1종 권한만 지원하며 운영자 기능은 다음 단계입니다.

추가 구현 예정: 카톡용 JPG, MC CSV 가져오기, 전단지 버전 및 복원, ZIP 백업,
               인쇄 이력, 사용자 역할 분리, 모바일 기능 강화.

안전 메모: 브라우저에 저장되는 것은 Supabase 공개 URL과 공개 키입니다.
회원 인증정보를 GitHub 저장소나 문서에 남기지 마세요.

V1.1 검토 보완 (2026-10-14)
- 등록된 전단지의 버전 정보는 최신 버전 순서로 정렬.
- 행사 기간 비교는 사용 PC의 로컬 날짜 기준.
- 연락처 오버레이는 A4 뒷면 아래쪽을 넘지 못하도록 검증.
- MC의 동일 이름+동일 전화번호 중복 등록 방지.
- 서버 접속 키 입력 시 publishable / 기존 anon 형식만 허용.

배포 체크리스트
[ ] 새 Supabase 프로젝트 생성 (기존 sk-sales-management 사용 금지)
[ ] setup.sql 실행 후 관리자 UID 등록
[ ] GitHub 새 저장소에 index.html, style.css, app.js만 업로드
[ ] GitHub Pages 주소에서 연결 및 로그인
[ ] 기본 원본 등록 -> MC 등록 -> 미리보기 -> PDF 저장
[ ] 실제 인쇄 A4 세로 2페이지 / 양면 긴 쪽 넘김 검증

중요: 이 파일만으로 서버가 자동 생성/배포되지는 않습니다.
