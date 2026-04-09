-- ============================================
-- TOTOBOLA · Supabase setup
-- Cola tudo isto no SQL Editor do Supabase e clica em "Run".
-- ============================================

-- 1) Tabela key-value que guarda todo o estado da app
create table if not exists public.kv_store (
  key         text primary key,
  value       jsonb,
  updated_at  timestamptz not null default now()
);

-- 2) Ativar Row Level Security
alter table public.kv_store enable row level security;

-- 3) Políticas: leitura e escrita públicas (a app é protegida por password no admin)
drop policy if exists "public read"   on public.kv_store;
drop policy if exists "public insert" on public.kv_store;
drop policy if exists "public update" on public.kv_store;

create policy "public read"   on public.kv_store for select using (true);
create policy "public insert" on public.kv_store for insert with check (true);
create policy "public update" on public.kv_store for update using (true) with check (true);

-- 4) Ativar realtime (para o site atualizar automaticamente quando há mudanças)
alter publication supabase_realtime add table public.kv_store;
