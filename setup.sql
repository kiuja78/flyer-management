-- Flyer Studio V1.0 | 신규 전용 Supabase 프로젝트에서 SQL Editor로 실행
-- 로그인 사용자는 Authentication > Users에서 만든 후 아래 마지막 INSERT에 UID 지정
create extension if not exists pgcrypto;
create table if not exists public.app_users (
 id uuid primary key references auth.users(id) on delete cascade,
 role text not null check (role in ('admin','operator')) default 'operator',
 active boolean not null default true,
 created_at timestamptz not null default now()
);
create table if not exists public.managers (
 id uuid primary key default gen_random_uuid(),
 display_name text not null,
 job_title text not null default '담당MC',
 phone_primary text not null,
 phone_secondary text,
 active boolean not null default true,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
create table if not exists public.flyers (
 id uuid primary key default gen_random_uuid(),
 brand text not null,
 category text,
 title text not null,
 model_codes text,
 campaign_type text,
 campaign_start date,
 campaign_end date,
 status text not null default 'active' check (status in ('active','archived')),
 created_at timestamptz not null default now()
);
create table if not exists public.flyer_versions (
 id uuid primary key default gen_random_uuid(),
 flyer_id uuid not null references public.flyers(id) on delete restrict,
 version_no int not null default 1,
 source_type text not null check (source_type in ('pdf','images')),
 pdf_path text,
 front_asset_path text,
 back_asset_path text,
 overlay_config jsonb not null default '{"x":22,"y":251,"w":166,"font":18,"color":"#12243a","align":"center"}'::jsonb,
 created_at timestamptz not null default now(),
 unique(flyer_id,version_no),
 check ((source_type='pdf' and pdf_path is not null) or (source_type='images' and front_asset_path is not null and back_asset_path is not null))
);
create index if not exists flyer_versions_flyer_idx on public.flyer_versions(flyer_id);
create index if not exists flyers_status_idx on public.flyers(status);
alter table public.app_users enable row level security;
alter table public.managers enable row level security;
alter table public.flyers enable row level security;
alter table public.flyer_versions enable row level security;
-- app_users 는 자신만 조회 가능하며 관리자 설정은 대시보드 SQL에서만 변경
create policy "own_role_read" on public.app_users for select to authenticated using (id=(select auth.uid()));
-- 별도의 app_users 조회에서 관리자 권한을 확인 (해당 테이블에 대한 순환 조회 없음)
create policy "admin_read_managers" on public.managers for select to authenticated using (exists(select 1 from public.app_users a where a.id=(select auth.uid()) and a.role='admin' and a.active));
create policy "admin_insert_managers" on public.managers for insert to authenticated with check (exists(select 1 from public.app_users a where a.id=(select auth.uid()) and a.role='admin' and a.active));
create policy "admin_update_managers" on public.managers for update to authenticated using (exists(select 1 from public.app_users a where a.id=(select auth.uid()) and a.role='admin' and a.active)) with check (exists(select 1 from public.app_users a where a.id=(select auth.uid()) and a.role='admin' and a.active));
create policy "admin_read_flyers" on public.flyers for select to authenticated using (exists(select 1 from public.app_users a where a.id=(select auth.uid()) and a.role='admin' and a.active));
create policy "admin_insert_flyers" on public.flyers for insert to authenticated with check (exists(select 1 from public.app_users a where a.id=(select auth.uid()) and a.role='admin' and a.active));
create policy "admin_update_flyers" on public.flyers for update to authenticated using (exists(select 1 from public.app_users a where a.id=(select auth.uid()) and a.role='admin' and a.active)) with check (exists(select 1 from public.app_users a where a.id=(select auth.uid()) and a.role='admin' and a.active));
create policy "admin_read_versions" on public.flyer_versions for select to authenticated using (exists(select 1 from public.app_users a where a.id=(select auth.uid()) and a.role='admin' and a.active));
create policy "admin_insert_versions" on public.flyer_versions for insert to authenticated with check (exists(select 1 from public.app_users a where a.id=(select auth.uid()) and a.role='admin' and a.active));
create policy "admin_update_versions" on public.flyer_versions for update to authenticated using (exists(select 1 from public.app_users a where a.id=(select auth.uid()) and a.role='admin' and a.active)) with check (exists(select 1 from public.app_users a where a.id=(select auth.uid()) and a.role='admin' and a.active));
-- Storage: 비공개 원본 버킷, 승인 관리자만 접근
insert into storage.buckets(id,name,public,file_size_limit,allowed_mime_types)
 values('flyer-originals','flyer-originals',false,31457280,array['application/pdf','image/png','image/jpeg'])
 on conflict (id) do nothing;
create policy "admin_originals_read" on storage.objects for select to authenticated using (bucket_id='flyer-originals' and exists(select 1 from public.app_users a where a.id=(select auth.uid()) and a.role='admin' and a.active));
create policy "admin_originals_upload" on storage.objects for insert to authenticated with check (bucket_id='flyer-originals' and exists(select 1 from public.app_users a where a.id=(select auth.uid()) and a.role='admin' and a.active));
create policy "admin_originals_cleanup" on storage.objects for delete to authenticated using (bucket_id='flyer-originals' and exists(select 1 from public.app_users a where a.id=(select auth.uid()) and a.role='admin' and a.active));
-- 인증된 사용자만 SQL 실행 권한, 실제 데이터 접근은 RLS로 제한
revoke all on public.app_users,public.managers,public.flyers,public.flyer_versions from anon;
grant select on public.app_users to authenticated;
grant select,insert,update on public.managers,public.flyers,public.flyer_versions to authenticated;
-- 중요: 관리자 등록(인증 사용자 생성 후 실제 UID로 변경하여 별도 실행)
-- insert into public.app_users(id,role,active) values ('AUTH_USER_UID_HERE','admin',true);
