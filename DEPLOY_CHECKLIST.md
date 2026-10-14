# 배포 작업표 V1.1

1. Supabase 새 프로젝트를 생성하세요. 기존 SK 영업관리 프로젝트와 반드시 분리합니다.
2. SQL Editor에서 `setup.sql` 실행. 인증 사용자 생성 후 관리자 UID로 `app_users` 행 등록.
3. GitHub 신규 저장소에서 `index.html`, `app.js`, `style.css`, `.nojekyll` 파일만 루트에 올립니다. `setup.sql`에는 비밀키를 입력하지 않습니다.
4. GitHub Pages: Settings > Pages > Deploy from a branch > main / (root).
5. Pages 주소에서 Supabase URL + publishable key를 입력하고 로그인합니다.
6. MC 등록, 담당자 없는 PDF 원본 등록, 연락처 위치 저장, A4 PDF 생성, 실제 양면 인쇄를 테스트합니다.

> 이 패키지는 배포를 위한 코드이며, 연결된 계정에 자동 배포된 상태가 아닙니다.
