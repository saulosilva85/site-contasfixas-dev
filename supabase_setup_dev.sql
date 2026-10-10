-- ============================================================
-- Contas Fixas — Script de criação do banco (ambiente DEV)
-- Rode isso no SQL Editor do projeto Supabase "contasfixas-dev"
-- ============================================================

-- Tabela de perfis (vinculada ao auth.users do Supabase)
create table if not exists profiles (
  id uuid references auth.users(id) on delete cascade primary key,
  name text,
  activated boolean default false,
  avatar_url text,
  created_at timestamptz default now()
);

alter table profiles enable row level security;

create policy "Ver próprio perfil" on profiles
  for select using (auth.uid() = id);

create policy "Inserir próprio perfil" on profiles
  for insert with check (auth.uid() = id);

create policy "Atualizar próprio perfil" on profiles
  for update using (auth.uid() = id);

create policy "Excluir próprio perfil" on profiles
  for delete using (auth.uid() = id);

-- Tabela de categorias (despesas fixas cadastradas pelo usuário)
create table if not exists categories (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  name text not null,
  created_at timestamptz default now()
);

alter table categories enable row level security;

create policy "Ver próprias categorias" on categories
  for select using (auth.uid() = user_id);

create policy "Inserir próprias categorias" on categories
  for insert with check (auth.uid() = user_id);

create policy "Atualizar próprias categorias" on categories
  for update using (auth.uid() = user_id);

create policy "Excluir próprias categorias" on categories
  for delete using (auth.uid() = user_id);

-- Tabela de lançamentos mensais (valores por categoria, por mês)
create table if not exists month_entries (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  category_id uuid references categories(id) on delete cascade not null,
  month_key text not null,
  amount numeric default 0,
  created_at timestamptz default now(),
  unique(user_id, category_id, month_key)
);

alter table month_entries enable row level security;

create policy "Ver próprios lançamentos" on month_entries
  for select using (auth.uid() = user_id);

create policy "Inserir próprios lançamentos" on month_entries
  for insert with check (auth.uid() = user_id);

create policy "Atualizar próprios lançamentos" on month_entries
  for update using (auth.uid() = user_id);

create policy "Excluir próprios lançamentos" on month_entries
  for delete using (auth.uid() = user_id);
