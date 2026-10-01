CREATE OR REPLACE FUNCTION definir_preco_item() RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE v_preco produtos.preco%TYPE;
BEGIN
SELECT preco INTO v_preco FROM produtos WHERE id_produto=NEW.id_produto;
IF NOT FOUND THEN RAISE EXCEPTION 'Produto % não encontrado.',NEW.id_produto; END IF;
NEW.preco_unitario:=v_preco;
RETURN NEW;
END; $$;
CREATE TRIGGER trg_definir_preco_item BEFORE INSERT ON itens_pedido FOR EACH ROW EXECUTE FUNCTION definir_preco_item();
-- INSERT INTO itens_pedido(id_pedido,id_produto,quantidade,preco_unitario) VALUES(2,1,1,1.00) RETURNING *;
