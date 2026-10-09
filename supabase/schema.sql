-- U compression: initial Supabase schema
-- Run this entire file in Supabase SQL Editor.
-- Public bucket means uploaded original images are publicly viewable/downloadable by URL.

create extension if not exists pgcrypto;

create table if not exists public.screenshots (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null check (char_length(title) between 1 and 100),
  game text not null default 'Other' check (char_length(game) between 1 and 80),
  file_path text not null unique,
  file_name text not null,
  mime_type text not null,
  file_size bigint not null check (file_size > 0 and file_size <= 26214400),
  created_at timestamptz not null default now()
);

alter table public.screenshots enable row level security;

drop policy if exists "Anyone can browse screenshots" on public.screenshots;
create policy "Anyone can browse screenshots"
on public.screenshots for select
to anon, authenticated
using (true);

drop policy if exists "Signed-in users can add their own screenshots" on public.screenshots;
create policy "Signed-in users can add their own screenshots"
on public.screenshots for insert
to authenticated
with check (auth.uid() = user_id);

drop policy if exists "Owners can delete their screenshots" on public.screenshots;
create policy "Owners can delete their screenshots"
on public.screenshots for delete
to authenticated
using (auth.uid() = user_id);

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'screenshots',
  'screenshots',
  true,
  26214400,
  array['image/png','image/jpeg','image/webp','image/gif','image/avif','image/bmp','image/tiff']
)
on conflict (id) do update set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "Anyone can view screenshot originals" on storage.objects;
create policy "Anyone can view screenshot originals"
on storage.objects for select
to anon, authenticated
using (bucket_id = 'screenshots');

drop policy if exists "Users can upload to their own folder" on storage.objects;
create policy "Users can upload to their own folder"
on storage.objects for insert
to authenticated
with check (
  bucket_id = 'screenshots'
  and (storage.foldername(name))[1] = auth.uid()::text
);

drop policy if exists "Users can delete their own files" on storage.objects;
create policy "Users can delete their own files"
on storage.objects for delete
to authenticated
using (
  bucket_id = 'screenshots'
  and (storage.foldername(name))[1] = auth.uid()::text
);
