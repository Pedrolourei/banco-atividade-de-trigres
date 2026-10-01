-- Ajuste ao esquema: auditoria(tabela,operacao,dados_anteriores,dados_novos,usuario_bd).
-- Dados JSONB; identificador e data com DEFAULT.
CREATE OR REPLACE FUNCTION auditar_clientes() RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN

IF TG_OP='INSERT' THEN
INSERT INTO auditoria(tabela,operacao,dados_anteriores,dados_novos,usuario_bd) VALUES(TG_TABLE_NAME,TG_OP,NULL,to_jsonb(NEW),CURRENT_USER);
ELSIF TG_OP='UPDATE' THEN
INSERT INTO auditoria(tabela,operacao,dados_anteriores,dados_novos,usuario_bd) VALUES(TG_TABLE_NAME,TG_OP,to_jsonb(OLD),to_jsonb(NEW),CURRENT_USER);
ELSE
INSERT INTO auditoria(tabela,operacao,dados_anteriores,dados_novos,usuario_bd) VALUES(TG_TABLE_NAME,TG_OP,to_jsonb(OLD),NULL,CURRENT_USER);
END IF;
RETURN NULL;
END; $$;
CREATE TRIGGER trg_auditoria_clientes AFTER INSERT OR UPDATE OR DELETE ON clientes FOR EACH ROW EXECUTE FUNCTION auditar_clientes();
-- INSERT INTO clientes(nome,email) VALUES('Daniel Rocha','daniel@email.com');
-- UPDATE clientes SET nome='Daniel Rocha Silva' WHERE email='daniel@email.com';
-- DELETE FROM clientes WHERE email='daniel@email.com';
-- SELECT * FROM auditoria WHERE tabela='clientes' ORDER BY id_auditoria DESC;
