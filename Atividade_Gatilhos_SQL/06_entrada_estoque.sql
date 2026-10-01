-- Ajuste ao esquema: movimentacoes_estoque(id_produto,tipo,quantidade).
-- Demais campos obrigatórios com DEFAULT; tipo deve aceitar ENTRADA.
CREATE TABLE entradas_estoque(id_entrada BIGSERIAL PRIMARY KEY,id_produto INTEGER NOT NULL REFERENCES produtos(id_produto),quantidade INTEGER NOT NULL CHECK(quantidade>0),observacao VARCHAR(255),criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP);
CREATE OR REPLACE FUNCTION registrar_entrada_estoque() RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
UPDATE produtos SET estoque=estoque+NEW.quantidade WHERE id_produto=NEW.id_produto;
INSERT INTO movimentacoes_estoque(id_produto,tipo,quantidade) VALUES(NEW.id_produto,'ENTRADA',NEW.quantidade);
RETURN NEW;
END; $$;
CREATE TRIGGER trg_registrar_entrada_estoque AFTER INSERT ON entradas_estoque FOR EACH ROW EXECUTE FUNCTION registrar_entrada_estoque();
-- INSERT INTO entradas_estoque(id_produto,quantidade,observacao) VALUES(1,10,'Reposição do fornecedor');
-- SELECT id_produto,nome,estoque FROM produtos WHERE id_produto=1;
-- SELECT * FROM movimentacoes_estoque ORDER BY id_movimentacao DESC;
