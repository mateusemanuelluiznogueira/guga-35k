-- Um WhatsApp = um número de peito (evita duplicar inscrição em outro slot).

create or replace function public.registrar_atleta(
  p_numero smallint,
  p_nome text,
  p_telefone text,
  p_distancia text,
  p_medalha boolean,
  p_almoco boolean,
  p_recado text
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_nome text := btrim(p_nome);
  v_telefone text := btrim(p_telefone);
  v_distancia text := btrim(p_distancia);
  v_recado text := btrim(coalesce(p_recado, ''));
  v_tel_digits text;
  v_row public.inscritos;
begin
  if p_numero is null or p_numero < 1 or p_numero > 40 then
    raise exception 'Escolhe um número de peito entre 1 e 40.';
  end if;

  if p_numero = 1 then
    raise exception 'O número 1 é do aniversariante.';
  end if;

  if v_nome is null or char_length(v_nome) < 1 or char_length(v_nome) > 80 then
    raise exception 'Informe seu nome ou apelido.';
  end if;

  if v_telefone is null or char_length(v_telefone) < 8 or char_length(v_telefone) > 20 then
    raise exception 'Informe um WhatsApp válido.';
  end if;

  if v_distancia is null or char_length(v_distancia) < 1 or char_length(v_distancia) > 40 then
    raise exception 'Informe a distância.';
  end if;

  if char_length(v_recado) > 500 then
    raise exception 'O recado ficou longo demais.';
  end if;

  if p_medalha is null or p_almoco is null then
    raise exception 'Confirme medalha e almoço.';
  end if;

  v_tel_digits := regexp_replace(v_telefone, '\D', '', 'g');

  if exists (
    select 1
    from public.inscritos_contato c
    where regexp_replace(c.telefone, '\D', '', 'g') = v_tel_digits
  ) then
    raise exception 'Esse WhatsApp já está inscrito com outro número de peito. Cada pessoa só pode garantir um número.';
  end if;

  if v_recado <> '' and (
    select count(*)
    from public.inscritos i
    join public.inscritos_contato c on c.numero = i.numero
    where regexp_replace(c.telefone, '\D', '', 'g') = v_tel_digits
      and btrim(i.recado) <> ''
  ) >= 3 then
    v_recado := '';
  end if;

  insert into public.inscritos (numero, nome, distancia, medalha, almoco, recado)
  values (p_numero, v_nome, v_distancia, p_medalha, p_almoco, v_recado)
  returning * into v_row;

  insert into public.inscritos_contato (numero, telefone)
  values (p_numero, v_telefone);

  return jsonb_build_object(
    'numero', v_row.numero,
    'nome', v_row.nome,
    'distancia', v_row.distancia,
    'medalha', v_row.medalha,
    'almoco', v_row.almoco,
    'recado', v_row.recado
  );
exception
  when unique_violation then
    raise exception 'Esse número de peito já foi escolhido. Escolhe outro.';
end;
$$;
