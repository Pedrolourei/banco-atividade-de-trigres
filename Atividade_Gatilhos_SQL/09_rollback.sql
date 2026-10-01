-- Requer triggers anteriores de estoque, movimentação e total. Ajuste IDs.
SELECT * FROM itens_pedido;
SELECT * FROM produtos;
SELECT * FROM pedidos;
SELECT * FROM movimentacoes_estoque;
BEGIN;
INSERT INTO itens_pedido(id_pedido,id_produto,quantidade,preco_unitario) VALUES(2,1,1,1.00);
SELECT * FROM itens_pedido;
SELECT * FROM produtos;
SELECT * FROM pedidos;
SELECT * FROM movimentacoes_estoque;
ROLLBACK;
SELECT * FROM itens_pedido;
SELECT * FROM produtos;
SELECT * FROM pedidos;
SELECT * FROM movimentacoes_estoque;
-- O item não permanece; alterações de estoque, movimentação e total são desfeitas.
-- Triggers participam da mesma transação da operação: atomicidade.
-- Sequências SERIAL/BIGSERIAL podem manter lacunas após rollback.
