CREATE OR REPLACE FUNCTION impedir_reabertura_pedido() RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
IF OLD.status='PAGO' AND NEW.status='ABERTO' THEN RAISE EXCEPTION 'Pedido pago não pode voltar para o status ABERTO.'; END IF;
RETURN NEW;
END; $$;
CREATE TRIGGER trg_impedir_reabertura_pedido BEFORE UPDATE ON pedidos FOR EACH ROW EXECUTE FUNCTION impedir_reabertura_pedido();
-- UPDATE pedidos SET status='ABERTO' WHERE id_pedido=1;
