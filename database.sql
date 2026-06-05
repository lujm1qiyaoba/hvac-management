-- 在 Supabase SQL Editor 里运行这段代码
-- Run this in Supabase SQL Editor

create table if not exists jobs (
  id uuid primary key default gen_random_uuid(),
  name text,
  phone text,
  addr text,
  type text default 'new',
  status text default 'lead',
  quote text,
  date date,
  notes_text text,
  checks jsonb default '{}',
  notes jsonb default '[]',
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- 允许所有人读写（无需登录）
-- Allow public read/write (no login required)
alter table jobs enable row level security;

create policy "Public access" on jobs
  for all using (true) with check (true);

-- 自动更新 updated_at
create or replace function update_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger jobs_updated_at
  before update on jobs
  for each row execute function update_updated_at();
