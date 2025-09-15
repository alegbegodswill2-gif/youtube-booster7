# YouTube Booster - Starter (Seeded)

This project is a starter bundle for the YouTube Booster service.

## What I seeded
- Admin user: alegbegodswill2@gmail.com (created in `users` table; set password via Supabase Auth or update `password_hash` field)
- 2 demo users (alice@example.com, bob@example.com) with sample subscriptions, payments, and reports.

## Quick start
1. Create a Supabase project and copy the URL and keys.
2. In Supabase SQL editor, run `sql/schema_and_seed.sql` to create tables and demo data.
3. Deploy the Edge Function `supabase/functions/check-expiries/index.ts` and schedule it hourly.
4. Set environment variables in Vercel from `.env.example`.
5. Push this repo to GitHub and deploy on Vercel.

