-- Corrige a tabela profiles do ambiente DEV, adicionando colunas que
-- faltavam (telefone, endereço, outras informações) e que o formulário
-- de perfil no despesas.html já tenta salvar.

alter table profiles add column if not exists phone text;
alter table profiles add column if not exists address text;
alter table profiles add column if not exists info text;
