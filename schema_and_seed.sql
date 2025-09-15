-- Supabase SQL schema for YouTube Booster (with seed data)
create table if not exists users (
  id uuid primary key default gen_random_uuid(),
  email text unique not null,
  password_hash text not null,
  channel_link text,
  created_at timestamptz default now()
);

create table if not exists payments (
  id bigint generated always as identity primary key,
  user_id uuid references users(id) on delete cascade,
  amount numeric(10,2) not null,
  currency text default 'USDT',
  network text default 'TRC20',
  status text default 'pending',
  tx_hash text,
  created_at timestamptz default now()
);

create table if not exists subscriptions (
  id bigint generated always as identity primary key,
  user_id uuid references users(id) on delete cascade,
  status text default 'expired',
  expires_at timestamptz,
  created_at timestamptz default now()
);

create table if not exists reports (
  id bigint generated always as identity primary key,
  user_id uuid references users(id) on delete cascade,
  subscribers integer,
  views integer,
  note text,
  created_at timestamptz default now()
);

create table if not exists admin_logs (
  id bigint generated always as identity primary key,
  admin_id text,
  action text,
  details text,
  created_at timestamptz default now()
);

-- Seed users
insert into users (id, email, password_hash, channel_link, created_at) values
  (gen_random_uuid(), 'alegbegodswill2@gmail.com', '$2b$10$adminplaceholderhash', NULL, now()),
  (gen_random_uuid(), 'alice@example.com', '$2b$10$fakehashalice', 'https://youtube.com/channel/UC111', now()),
  (gen_random_uuid(), 'bob@example.com', '$2b$10$fakehashbob', 'https://youtube.com/channel/UC222', now());

-- For the seeded payments/subscriptions/reports we need the user ids. We'll insert using subselects.

-- Seed a confirmed payment and active subscription for alice
insert into payments (user_id, amount, status, tx_hash, created_at)
values (
  (select id from users where email='alice@example.com'),
  0.7,
  'confirmed',
  '0xABC123TRONHASH',
  now() - interval '1 day'
);

insert into subscriptions (user_id, status, expires_at, created_at)
values (
  (select id from users where email='alice@example.com'),
  'active',
  '2025-09-16T19:35:34.239509Z',
  now() - interval '1 day'
);

insert into reports (user_id, subscribers, views, note, created_at)
values (
  (select id from users where email='alice@example.com'),
  15,
  340,
  'Demo report for Alice',
  now() - interval '1 day'
);

-- Seed a pending payment and expired subscription for bob
insert into payments (user_id, amount, status, tx_hash, created_at)
values (
  (select id from users where email='bob@example.com'),
  0.7,
  'pending',
  '0xDEF456TRONHASH',
  now() - interval '2 hours'
);

insert into subscriptions (user_id, status, expires_at, created_at)
values (
  (select id from users where email='bob@example.com'),
  'expired',
  '2025-09-14T19:35:34.239509Z',
  now() - interval '2 days'
);

insert into reports (user_id, subscribers, views, note, created_at)
values (
  (select id from users where email='bob@example.com'),
  5,
  120,
  'Demo report for Bob',
  now() - interval '2 days'
);

-- Seed admin_logs
insert into admin_logs (admin_id, action, details, created_at) values
  ('alegbegodswill2@gmail.com', 'Seeded Admin', 'Admin account created', now()),
  ('system', 'Seed', 'Demo users and payments seeded', now());
