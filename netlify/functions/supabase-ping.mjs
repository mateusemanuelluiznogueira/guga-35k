import { pingSupabase } from './lib/ping-supabase.mjs';

/** Ping manual (sem cron). O agendado é supabase-keepalive (de hora em hora). */
export default async () => {
  const { ok, status, text } = await pingSupabase();
  return new Response(
    JSON.stringify({ ok, status, body: text.slice(0, 120) }),
    {
      status: ok ? 200 : 502,
      headers: { 'content-type': 'application/json; charset=utf-8' },
    }
  );
};
