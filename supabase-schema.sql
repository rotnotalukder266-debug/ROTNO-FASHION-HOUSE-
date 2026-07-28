-- ============================================
-- Rotno Fashion House — Supabase Database Schema
-- এই পুরো ফাইলটা Supabase Dashboard > SQL Editor এ পেস্ট করে "Run" চাপুন
-- ============================================

create extension if not exists "uuid-ossp";

-- প্রোডাক্ট টেবিল
create table if not exists products (
  id uuid primary key default uuid_generate_v4(),
  name text not null,
  category text not null,
  price numeric not null,
  cost numeric default 0,
  stock int default 0,
  sold int default 0,
  image text,
  description text,
  created_at timestamptz default now()
);

-- রিভিউ ও রেটিং
create table if not exists reviews (
  id uuid primary key default uuid_generate_v4(),
  product_id uuid references products(id) on delete cascade,
  name text not null,
  phone text not null,
  rating int not null check (rating between 1 and 5),
  review_text text,
  image text,
  created_at timestamptz default now()
);

-- অর্ডার
create table if not exists orders (
  id uuid primary key default uuid_generate_v4(),
  customer_name text not null,
  phone text not null,
  address text not null,
  items jsonb not null,
  total numeric not null,
  coupon_applied boolean default false,
  cashback_from_coupon numeric default 0,
  status text default 'পেন্ডিং',
  created_at timestamptz default now()
);

-- ওয়ালেট (ফোন নাম্বার দিয়ে আইডেন্টিফাই হবে)
create table if not exists wallets (
  phone text primary key,
  balance numeric default 0
);

-- ওয়ালেট লেনদেনের হিস্ট্রি
create table if not exists wallet_transactions (
  id uuid primary key default uuid_generate_v4(),
  phone text not null,
  type text not null check (type in ('credit','debit')),
  amount numeric not null,
  reason text,
  created_at timestamptz default now()
);

-- উইথড্র রিকোয়েস্ট
create table if not exists withdrawals (
  id uuid primary key default uuid_generate_v4(),
  phone text not null,
  amount numeric not null,
  method text not null,
  number text not null,
  status text default 'পেন্ডিং',
  created_at timestamptz default now()
);

-- কুপন/ক্যাম্পেইন সেটিংস (সবসময় ১টা রো থাকবে)
create table if not exists coupon_config (
  id int primary key default 1,
  code text default 'ROTNOEID',
  min_order numeric default 550,
  cashback numeric default 50,
  active boolean default true,
  note text default '৫৫০+ টাকার অর্ডারে কুপন কোড ব্যবহার করলেই ক্যাশব্যাক!'
);
insert into coupon_config (id) values (1) on conflict (id) do nothing;

-- হিসাব-নিকাশ (পণ্য ক্রয় এন্ট্রি + অন্যান্য খরচ)
create table if not exists accounting_entries (
  id uuid primary key default uuid_generate_v4(),
  entry_type text not null check (entry_type in ('purchase','expense')),
  product_id uuid references products(id),
  qty int,
  unit_cost numeric,
  note text,
  amount numeric not null,
  entry_date date default current_date,
  created_at timestamptz default now()
);

-- ============================================
-- Row Level Security (RLS) — MVP/ডেমোর জন্য খোলা রাখা হলো
-- সতর্কতা: এটা প্রোডাকশন-গ্রেড সিকিউর না। ভবিষ্যতে Supabase Auth
-- দিয়ে অ্যাডমিন-অনলি write policy বসাতে হবে।
-- ============================================
alter table products enable row level security;
alter table reviews enable row level security;
alter table orders enable row level security;
alter table wallets enable row level security;
alter table wallet_transactions enable row level security;
alter table withdrawals enable row level security;
alter table coupon_config enable row level security;
alter table accounting_entries enable row level security;

create policy "public read products" on products for select using (true);
create policy "public write products" on products for insert with check (true);
create policy "public update products" on products for update using (true);
create policy "public delete products" on products for delete using (true);

create policy "public read reviews" on reviews for select using (true);
create policy "public write reviews" on reviews for insert with check (true);

create policy "public read orders" on orders for select using (true);
create policy "public write orders" on orders for insert with check (true);
create policy "public update orders" on orders for update using (true);

create policy "public read wallets" on wallets for select using (true);
create policy "public write wallets" on wallets for insert with check (true);
create policy "public update wallets" on wallets for update using (true);

create policy "public read wallet_tx" on wallet_transactions for select using (true);
create policy "public write wallet_tx" on wallet_transactions for insert with check (true);

create policy "public read withdrawals" on withdrawals for select using (true);
create policy "public write withdrawals" on withdrawals for insert with check (true);
create policy "public update withdrawals" on withdrawals for update using (true);

create policy "public read coupon" on coupon_config for select using (true);
create policy "public update coupon" on coupon_config for update using (true);

create policy "public read accounting" on accounting_entries for select using (true);
create policy "public write accounting" on accounting_entries for insert with check (true);

-- ============================================
-- Storage buckets (ছবি আপলোডের জন্য)
-- এগুলো Dashboard > Storage থেকেও তৈরি করা যায়, অথবা এখান থেকেই:
-- ============================================
insert into storage.buckets (id, name, public)
values ('product-images', 'product-images', true)
on conflict (id) do nothing;

insert into storage.buckets (id, name, public)
values ('review-images', 'review-images', true)
on conflict (id) do nothing;

create policy "public upload product images" on storage.objects
  for insert with check (bucket_id = 'product-images');
create policy "public read product images" on storage.objects
  for select using (bucket_id = 'product-images');

create policy "public upload review images" on storage.objects
  for insert with check (bucket_id = 'review-images');
create policy "public read review images" on storage.objects
  for select using (bucket_id = 'review-images');
