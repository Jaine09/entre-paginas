

create table if not exists public.clubs (
  id         bigint generated always as identity primary key,
  nome       text not null check (char_length(nome) between 1 and 80),
  cidade     text check (char_length(cidade) <= 60),
  formato    text not null check (formato in ('Presencial','Online','Híbrido')),
  genero     text,
  freq       text check (freq in ('Semanal','Quinzenal','Mensal')),
  descricao  text not null check (char_length(descricao) between 1 and 400),
  contato    text not null check (char_length(contato) between 1 and 100),
  created_at timestamptz not null default now()
);

create table if not exists public.interests (
  id         bigint generated always as identity primary key,
  club_id    bigint not null references public.clubs(id) on delete cascade,
  nome       text not null check (char_length(nome) between 1 and 40),
  msg        text check (char_length(msg) <= 140),
  created_at timestamptz not null default now()
);

-- Segurança (RLS): o público só pode LER e CRIAR. Não pode editar nem apagar.
alter table public.clubs     enable row level security;
alter table public.interests enable row level security;

drop policy if exists "clubs_ler"    on public.clubs;
drop policy if exists "clubs_criar"  on public.clubs;
drop policy if exists "int_ler"      on public.interests;
drop policy if exists "int_criar"    on public.interests;

create policy "clubs_ler"   on public.clubs     for select to anon, authenticated using (true);
create policy "clubs_criar" on public.clubs     for insert to anon, authenticated with check (true);
create policy "int_ler"     on public.interests for select to anon, authenticated using (true);
create policy "int_criar"   on public.interests for insert to anon, authenticated with check (true);

-- Permissões das tabelas para o acesso público
grant usage on schema public to anon, authenticated;
grant select, insert on public.clubs, public.interests to anon, authenticated;

-- Clubes iniciais de exemplo (só entram se a tabela estiver vazia)
insert into public.clubs (nome, cidade, formato, genero, freq, descricao, contato)
select * from (values
  ('Leitores da Paulista','São Paulo/SP','Presencial','Literatura brasileira','Mensal','Encontros mensais para debater autores brasileiros, com café e conversa leve.','@leitoresdapaulista'),
  ('Clube Páginas Online','Online','Online','Variados','Quinzenal','Clube por videochamada, cada encontro com um gênero diferente.','paginasonline@email.com')
) as v(nome,cidade,formato,genero,freq,descricao,contato)
where not exists (select 1 from public.clubs);
