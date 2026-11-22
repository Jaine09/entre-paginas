# 📚 Entre Páginas

App (PWA) gratuito para divulgar clubes de leitura, demonstrar interesse em participar e gerar roteiros de debate.

## Recursos
- Cadastro de clubes e busca/filtro
- "Tenho interesse" em cada clube
- Gerador de roteiro de debate (por gênero e duração)
- Instalável (Android, iOS, desktop) e funciona offline

## Rodar localmente
`python3 -m http.server 8000` e abra http://localhost:8000

## Publicar (GitHub Pages)
Settings → Pages → Branch `main` / root. Abra a URL no celular e use "Instalar app" / "Adicionar à tela inicial".

## Banco de dados (Supabase)
1. Crie um projeto gratuito em supabase.com.
2. SQL Editor > New query: cole o conteúdo de `supabase.sql` e execute (cria tabelas, regras de segurança e clubes iniciais).
3. Project Settings > API: copie a **Project URL** e a chave **anon public** para o `config.js`.
4. Faça commit/push. Sem preencher o `config.js`, o app funciona só com dados locais do navegador.

Segurança: o público só pode ler e criar registros (RLS ativo, sem update/delete). Nunca coloque a chave `service_role` no front-end. Os contatos cadastrados são públicos.

## Licença
MIT
