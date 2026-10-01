CREATE OR REPLACE FUNCTION bloquear_exclusao_produto() RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
IF EXISTS(SELECT 1 FROM historico_precos WHERE id_produto=OLD.id_produto) THEN RAISE EXCEPTION 'Produto com histórico de preços não pode ser excluído.'; END IF;
RETURN OLD;
END; $$;
CREATE TRIGGER trg_bloquear_exclusao_produto BEFORE DELETE ON produtos FOR EACH ROW EXECUTE FUNCTION bloquear_exclusao_produto();
-- DELETE FROM produtos WHERE id_produto=(SELECT id_produto FROM historico_precos LIMIT 1);
