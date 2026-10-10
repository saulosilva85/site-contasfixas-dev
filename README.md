# Contas Fixas — Ambiente de Desenvolvimento

Este repositório é o **ambiente de testes** do site [Contas Fixas](https://www.contasfixas.com.br).
Ele é publicado separadamente em **dev.contasfixas.com.br**, com seu próprio banco de dados
Supabase e credenciais de teste do Mercado Pago — totalmente isolado da produção.

## Por que existe

Permite testar mudanças (novas funcionalidades, ajustes de layout, correções) antes de
publicá-las para os clientes reais no repositório de produção
(`saulosilva85/site-contasfixas`).

## Diferenças em relação à produção

| | Produção | Este repositório (dev) |
|---|---|---|
| Domínio | www.contasfixas.com.br | dev.contasfixas.com.br |
| Banco de dados | Projeto Supabase de produção | Projeto Supabase `contasfixas-dev` |
| Pagamento Pix | Credenciais reais do Mercado Pago | Credenciais de **teste/sandbox** |
| Dados | Clientes reais | Fictícios — pode apagar/testar à vontade |

## Fluxo de trabalho

1. Alterações são feitas e testadas aqui primeiro
2. Validado em dev.contasfixas.com.br
3. A mudança é replicada para o repositório de produção
   (`saulosilva85/site-contasfixas`), com as credenciais corretas de produção

## Arquivos

- `despesas.html` — aplicativo completo (idêntico em estrutura ao de produção, exceto pelas
  credenciais do Supabase e o banner vermelho "AMBIENTE DE TESTES" no topo)
- `termos.html` / `politica-privacidade.html` — páginas legais (mesmo conteúdo da produção)
- `CNAME` — configura o domínio customizado do GitHub Pages

## Configuração pendente

- [ ] Criar projeto Supabase `contasfixas-dev` e atualizar a URL/chave em `despesas.html`
      (bloco `CONFIG DEV` no início do `<script>`)
- [ ] Rodar o script SQL de criação das tabelas nesse novo projeto
- [ ] Criar as Edge Functions (`create-pix`, `mp-webhook`, `delete-account`) usando
      credenciais de **teste** do Mercado Pago
- [ ] Criar o registro DNS `dev` (CNAME) no registro.br apontando para `saulosilva85.github.io`
- [ ] Ativar GitHub Pages neste repositório com domínio customizado `dev.contasfixas.com.br`
