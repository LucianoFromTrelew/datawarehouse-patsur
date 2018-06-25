create or replace function get_id_tiempo(anio integer, mes integer) returns integer as
$$
declare
	id_tiempo integer;proximo integer;
begin
	id_tiempo = (select t.id_tiempo from tiempo t where t.anio = $1 and t.mes = $2);
	
	if id_tiempo is not null then
		return id_tiempo;
	else
		proximo = (select max(t.id_tiempo) from tiempo t) + 1;
		if proximo is null then
			proximo = 1;
		end if;
		insert into tiempo values(proximo, $1, $2);
		
		id_tiempo = proximo;
		return id_tiempo;
	end if;
	end;
$$ language plpgsql;

CREATE OR REPLACE FUNCTION get_random_sucursal() RETURNS SETOF distribucion_geografica AS $$
/*
    Devuelve una sucursal aleatoria
    No recibe nada
    Devuelve un registro de la tabla distribucion_geografica
*/
BEGIN
    RETURN QUERY
    SELECT *
    FROM distribucion_geografica
    ORDER BY random()
    LIMIT 1;
END;
$$ LANGUAGE plpgsql;


