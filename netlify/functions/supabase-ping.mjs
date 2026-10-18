const REST_URL =
  'https://qskzgjdndyudpbwdyzph.supabase.co/rest/v1/inscritos?select=numero&limit=1';
const ANON_KEY =
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFza3pnamRuZHl1ZHBid2R5enBoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTE5MzcyNDUsImV4cCI6MjEwNzUxMzI0NX0.PJGa7ieQS0gBPFIzOmdVHBmMYqIz2FxrHdbcQLFdxl0';

/** Ping manual (sem cron). O agendado é supabase-keepalive. */
export default async () => {
  const res = await fetch(REST_URL, {
    headers: {
      apikey: ANON_KEY,
      Authorization: `Bearer ${ANON_KEY}`,
    },
  });
  const body = await res.text();
  return new Response(
    JSON.stringify({ ok: res.ok, status: res.status, body: body.slice(0, 120) }),
    {
      status: res.ok ? 200 : 502,
      headers: { 'content-type': 'application/json; charset=utf-8' },
    }
  );
};
