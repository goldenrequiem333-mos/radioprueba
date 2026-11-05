create table if not exists public.stations (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  city text not null,
  genre text not null,
  frequency text,
  description text,
  logo_url text not null,
  cover_url text not null,
  stream_url text,
  created_at timestamptz not null default now()
);

alter table public.stations enable row level security;
drop policy if exists "Anyone can read stations" on public.stations;
create policy "Anyone can read stations" on public.stations for select using (true);
drop policy if exists "Anyone can add stations" on public.stations;
drop policy if exists "Anyone can delete stations" on public.stations;
drop policy if exists "Only admin can add stations" on public.stations;
drop policy if exists "Only admin can delete stations" on public.stations;
create policy "Only admin can add stations" on public.stations for insert with check ((select auth.jwt() ->> 'email') = 'goldenrequiem333@gmail.com');
create policy "Only admin can delete stations" on public.stations for delete using ((select auth.jwt() ->> 'email') = 'goldenrequiem333@gmail.com');

insert into storage.buckets (id, name, public)
values ('station-images', 'station-images', true)
on conflict (id) do update set public = true;

drop policy if exists "Anyone can read station images" on storage.objects;
drop policy if exists "Only admin can upload station images" on storage.objects;
drop policy if exists "Only admin can delete station images" on storage.objects;
create policy "Anyone can read station images" on storage.objects for select using (bucket_id = 'station-images');
create policy "Only admin can upload station images" on storage.objects for insert with check (bucket_id = 'station-images' and (select auth.jwt() ->> 'email') = 'goldenrequiem333@gmail.com');
create policy "Only admin can delete station images" on storage.objects for delete using (bucket_id = 'station-images' and (select auth.jwt() ->> 'email') = 'goldenrequiem333@gmail.com');
