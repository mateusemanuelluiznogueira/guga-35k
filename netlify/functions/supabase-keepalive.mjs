import { pingSupabase } from './lib/ping-supabase.mjs';

/** Ping horário — free tier pausa após ~7 dias sem atividade no banco. */
export default async (req) => {
  let nextRun;
  try {
    const body = await req.json();
    nextRun = body?.next_run;
  } catch {
    /* invocação manual */
  }

  const { ok, status, text } = await pingSupabase();
  const snippet = text.slice(0, 200);
  console.log('supabase-keepalive', { status, nextRun, snippet });

  return new Response(
    JSON.stringify({ ok, status, next_run: nextRun ?? null }),
    {
      status: ok ? 200 : 502,
      headers: { 'content-type': 'application/json; charset=utf-8' },
    }
  );
};

export const config = {
  schedule: '0 * * * *',
};
