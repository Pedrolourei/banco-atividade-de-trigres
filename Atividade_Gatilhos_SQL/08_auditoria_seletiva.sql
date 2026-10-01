-- Ajuste ao esquema: auditoria(tabela,operacao,dados_anteriores,dados_novos,usuario_bd).
-- Dados JSONB; identificador e data com DEFAULT.
CREATE OR REPLACE FUNCTION auditar_produtos_seletivamente() RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
IF TG_OP='UPDATE' THEN
IF NOT(OLD.nome IS DISTINCT FROM NEW.nome OR OLD.preco IS DISTINCT FROM NEW.preco OR OLD.estoque IS DISTINCT FROM NEW.estoque OR OLD.ativo IS DISTINCT FROM NEW.ativo) THEN RETURN NULL; END IF;
END IF;
IF TG_OP='INSERT' THEN
INSERT INTO auditoria(tabela,operacao,dados_anteriores,dados_novos,usuario_bd) VALUES(TG_TABLE_NAME,TG_OP,NULL,to_jsonb(NEW),CURRENT_USER);
ELSIF TG_OP='UPDATE' THEN
INSERT INTO auditoria(tabela,operacao,dados_anteriores,dados_novos,usuario_bd) VALUES(TG_TABLE_NAME,TG_OP,to_jsonb(OLD),to_jsonb(NEW),CURRENT_USER);
ELSE
INSERT INTO auditoria(tabela,operacao,dados_anteriores,dados_novos,usuario_bd) VALUES(TG_TABLE_NAME,TG_OP,to_jsonb(OLD),NULL,CURRENT_USER);
END IF;
RETURN NULL;
END; $$;
-- Ajuste o nome para a trigger antiga real, evitando duplicidade.
DROP TRIGGER IF EXISTS trg_auditoria_produtos ON produtos;
CREATE TRIGGER trg_auditoria_produtos AFTER INSERT OR UPDATE OR DELETE ON produtos FOR EACH ROW EXECUTE FUNCTION auditar_produtos_seletivamente();
-- Não deve auditar:
-- UPDATE produtos SET atualizado_em=CURRENT_TIMESTAMP WHERE id_produto=1;
-- Deve auditar:
-- UPDATE produtos SET preco=preco+1 WHERE id_produto=1;
