-- Adiciona suporte a despesas parceladas (ex: compra no cartão em várias
-- vezes) na tabela categories do ambiente DEV.
--
-- Categorias existentes continuam com essas colunas em NULL, o que mantém
-- o comportamento atual intacto: aparecem em todos os meses, como sempre.
-- Só passam a ficar "limitadas" a um intervalo de meses as categorias
-- novas que forem criadas marcando a opção "Compra parcelada".

alter table categories add column if not exists start_month text;
alter table categories add column if not exists installments integer;
