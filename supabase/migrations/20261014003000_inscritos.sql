-- Pelotão público. Telefone fica em inscritos_contato, sem leitura anônima.

create table if not exists public.inscritos (
  numero smallint primary key,
  nome text not null,
  distancia text not null,
  medalha boolean not null,
  almoco boolean not null,
  recado text not null default '',
  created_at timestamptz not null default now(),
  constraint inscritos_numero_range check (numero between 1 and 40),
  constraint inscritos_nome_len check (char_length(btrim(nome)) between 1 and 80),
  constraint inscritos_distancia_len check (char_length(btrim(distancia)) between 1 and 40),
  constraint inscritos_recado_len check (char_length(recado) <= 500)
);

create table if not exists public.inscritos_contato (
  numero smallint primary key references public.inscritos (numero) on delete cascade,
  telefone text not null,
  constraint inscritos_contato_telefone_len check (char_length(btrim(telefone)) between 8 and 20)
);

alter table public.inscritos enable row level security;
alter table public.inscritos_contato enable row level security;

revoke all on table public.inscritos from anon, authenticated;
revoke all on table public.inscritos_contato from anon, authenticated;

grant select on table public.inscritos to anon, authenticated;

drop policy if exists inscritos_leitura on public.inscritos;
create policy inscritos_leitura on public.inscritos
  for select
  to anon, authenticated
  using (true);

insert into public.inscritos (numero, nome, distancia, medalha, almoco, recado)
values (1, 'Guga', '35km', true, true, '')
on conflict (numero) do nothing;

insert into public.inscritos_contato (numero, telefone)
values (1, '4197333676')
on conflict (numero) do nothing;

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

  if v_recado <> '' and (
    select count(*)
    from public.inscritos i
    join public.inscritos_contato c on c.numero = i.numero
    where regexp_replace(c.telefone, '\D', '', 'g') = regexp_replace(v_telefone, '\D', '', 'g')
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

revoke all on function public.registrar_atleta(smallint, text, text, text, boolean, boolean, text) from public;
grant execute on function public.registrar_atleta(smallint, text, text, text, boolean, boolean, text) to anon, authenticated;

do $$
begin
  if not exists (
    select 1
    from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'inscritos'
  ) then
    alter publication supabase_realtime add table public.inscritos;
  end if;
end $$;

notify pgrst, 'reload schema';
