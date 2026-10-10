import { createClient } from "jsr:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const authHeader = req.headers.get("Authorization")!;
    const supabaseUser = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_ANON_KEY")!,
      { global: { headers: { Authorization: authHeader } } }
    );

    const { data: { user }, error: userErr } = await supabaseUser.auth.getUser();
    if (userErr || !user) {
      return new Response(JSON.stringify({ error: "Não autenticado" }), {
        status: 401,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const accessToken = Deno.env.get("MERCADOPAGO_ACCESS_TOKEN")!;

    const mpResp = await fetch("https://api.mercadopago.com/v1/orders", {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${accessToken}`,
        "Content-Type": "application/json",
        "X-Idempotency-Key": crypto.randomUUID(),
      },
      body: JSON.stringify({
        type: "online",
        total_amount: "20.00",
        external_reference: user.id,
        // "APRO" em sandbox faz o Mercado Pago aprovar o Pix automaticamente.
        // Em produção este campo não tem esse efeito especial.
        payer: { email: user.email, first_name: "APRO" },
        transactions: {
          payments: [
            {
              amount: "20.00",
              payment_method: { id: "pix", type: "bank_transfer" },
            },
          ],
        },
      }),
    });

    const mpData = await mpResp.json();

    if (!mpResp.ok) {
      return new Response(JSON.stringify({ error: "Erro ao criar pagamento", details: mpData }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const transaction = mpData.transactions?.payments?.[0];
    const qrData = transaction?.payment_method?.qr_code;
    const qrBase64 = transaction?.payment_method?.qr_code_base64;

    return new Response(JSON.stringify({
      orderId: mpData.id,
      qr_code: qrData,
      qr_code_base64: qrBase64,
    }), {
      status: 200,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (e) {
    return new Response(JSON.stringify({ error: String(e) }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
