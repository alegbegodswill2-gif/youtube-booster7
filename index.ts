// Supabase Edge Function: check-expiries
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
const supabase = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);

Deno.serve(async () => {
  const now = new Date().toISOString();
  const { data: subs, error } = await supabase
    .from("subscriptions")
    .select("id, user_id, expires_at")
    .eq("status", "active")
    .lt("expires_at", now);

  if (error) {
    console.error("Error fetching subs:", error);
    return new Response("Error", { status: 500 });
  }

  if (!subs || subs.length === 0) {
    return new Response("No expiries found", { status: 200 });
  }

  for (const sub of subs) {
    await supabase.from("subscriptions").update({ status: "expired" }).eq("id", sub.id);
    await supabase.from("admin_logs").insert({
      admin_id: "system",
      action: "Subscription Expired",
      details: `User ${sub.user_id} subscription expired at ${sub.expires_at}`
    });
  }

  return new Response(`Expired ${subs.length} subscriptions`, { status: 200 });
});
