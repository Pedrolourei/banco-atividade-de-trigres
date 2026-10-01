CREATE OR REPLACE FUNCTION registrar_status_pedido() RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
INSERT INTO historico_status_pedido(id_pedido,status_anterior,status_novo,usuario_bd) VALUES(NEW.id_pedido,OLD.status,NEW.status,CURRENT_USER);
RETURN NEW;
END; $$;
CREATE TRIGGER trg_historico_status_pedido AFTER UPDATE ON pedidos FOR EACH ROW WHEN(OLD.status IS DISTINCT FROM NEW.status) EXECUTE FUNCTION registrar_status_pedido();
-- UPDATE pedidos SET status='PAGO' WHERE id_pedido=1;
-- SELECT * FROM historico_status_pedido ORDER BY id_historico DESC;
