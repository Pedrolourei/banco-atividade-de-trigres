CREATE OR REPLACE FUNCTION validar_pedido_do_item() RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE v_status pedidos.status%TYPE;
BEGIN
SELECT status INTO v_status FROM pedidos WHERE id_pedido=NEW.id_pedido FOR UPDATE;
IF NOT FOUND THEN RAISE EXCEPTION 'Pedido % não encontrado.',NEW.id_pedido; END IF;
IF v_status='CANCELADO' THEN RAISE EXCEPTION 'Não é permitido adicionar itens a um pedido cancelado.'; END IF;
RETURN NEW;
END; $$;
CREATE TRIGGER trg_validar_pedido_do_item BEFORE INSERT ON itens_pedido FOR EACH ROW EXECUTE FUNCTION validar_pedido_do_item();
-- INSERT INTO pedidos(id_cliente,status) VALUES(3,'CANCELADO') RETURNING id_pedido;
-- Substitua ID_RETORNADO pelo identificador retornado:
-- INSERT INTO itens_pedido(id_pedido,id_produto,quantidade,preco_unitario) VALUES(ID_RETORNADO,1,1,350);
