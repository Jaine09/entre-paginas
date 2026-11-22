-- Entre Páginas: rode no Supabase em SQL Editor > New query > Run
create table if not exists public.clubs (
  id uuid primary key default gen_random_uuid(),
  nome text not null check (char_length(nome) between 2 and 80),
  cidade text check (char_length(cidade) <= 60),
  formato text not null check (formato in ('Presencial','Online','Híbrido')),
  genero text not null check (char_length(genero) <= 40),
  freq text not null check (freq in ('Semanal','Quinzenal','Mensal')),
  descricao text not null check (char_length(descricao) between 5 and 400),
  contato text not null check (char_length(contato) between 3 and 100),
  created_at timestamptz not null default now()
);
create table if not exists public.interests (
  id uuid primary key default gen_random_uuid(),
  club_id uuid not null references public.clubs(id) on delete cascade,
  nome text not null check (char_length(nome) between 1 and 40),
  msg text check (char_length(msg) <= 140),
  created_at timestamptz not null default now()
);
create index if not exists interests_club_idx on public.interests(club_id);

alter table public.clubs enable row level security;
alter table public.interests enable row level security;
-- leitura e criação públicas; sem update/delete para o público
create policy "clubs_read"   on public.clubs     for select to anon using (true);
create policy "clubs_insert" on public.clubs     for insert to anon with check (true);
create policy "int_read"     on public.interests for select to anon using (true);
create policy "int_insert"   on public.interests for insert to anon with check (true);

-- Clubes iniciais (confira os contatos antes de divulgar)
insert into public.clubs (nome,cidade,formato,genero,freq,descricao,contato) values
('Leia Mulheres','Todo o Brasil','Presencial','Variados','Mensal','Rede nacional de clubes que lê autoras mulheres, com grupos em várias cidades. Procure o grupo da sua cidade.','Instagram @leiamulheres'),
('TAG Experiências Literárias','Online','Online','Variados','Mensal','Clube de assinatura com curadoria mensal de livros e comunidade de leitores.','taglivros.com'),
('Clube de Clássicos (exemplo)','São Paulo/SP','Híbrido','Clássicos','Mensal','Exemplo de cadastro: encontros mensais para ler e debater clássicos da literatura. Apague ou edite.','exemplo@email.com'),
('Fantasia & Café (exemplo)','Online','Online','Fantasia','Quinzenal','Exemplo de cadastro: leitura de fantasia e ficção científica com debate por videochamada.','exemplo@email.com');
