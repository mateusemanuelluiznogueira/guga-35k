const REST_URL =
  'https://qskzgjdndyudpbwdyzph.supabase.co/rest/v1/inscritos?select=numero&limit=1';
const ANON_KEY =
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFza3pnamRuZHl1ZHBid2R5enBoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTE5MzcyNDUsImV4cCI6MjEwNzUxMzI0NX0.PJGa7ieQS0gBPFIzOmdVHBmMYqIz2FxrHdbcQLFdxl0';

/** Ping diário para o projeto Supabase free não pausar por inatividade. */
export default async (req) => {
  let nextRun;
  try {
    const body = await req.json();
    nextRun = body?.next_run;
  } catch {
    /* chamada manual via browser/curl */
  }

  const res = await fetch(REST_URL, {
    headers: {
      apikey: ANON_KEY,
      Authorization: `Bearer ${ANON_KEY}`,
    },
  });
  const snippet = (await res.text()).slice(0, 200);
  console.log('supabase-keepalive', { status: res.status, nextRun, snippet });

  return new Response(
    JSON.stringify({ ok: res.ok, status: res.status, next_run: nextRun ?? null }),
    {
      status: res.ok ? 200 : 502,
      headers: { 'content-type': 'application/json; charset=utf-8' },
    }
  );
};

export const config = {
  schedule: '15 9 * * *',
};
