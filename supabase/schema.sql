create type public.user_role as enum ('customer','admin');
create type public.product_status as enum ('draft','active','archived');
create table public.profiles(id uuid primary key references auth.users(id) on delete cascade,role public.user_role not null default 'customer',display_name text,created_at timestamptz not null default now());
create table public.products(id uuid primary key default gen_random_uuid(),slug text unique not null,name_zh text not null,name_en text not null,description_zh text not null default '',description_en text not null default '',price integer not null check(price>=0),stock integer not null default 0 check(stock>=0),category text not null default 'uncategorized',status public.product_status not null default 'draft',featured boolean not null default false,created_at timestamptz not null default now());
create table public.product_images(id uuid primary key default gen_random_uuid(),product_id uuid not null references public.products(id) on delete cascade,image_url text not null,sort_order integer not null default 0);
create table public.site_content(id uuid primary key default gen_random_uuid(),content_key text unique not null,value_zh text not null default '',value_en text not null default '');
create table public.orders(id uuid primary key default gen_random_uuid(),customer_id uuid references auth.users(id),order_number text unique not null,status text not null default 'pending',total integer not null,shipping_method text,shipping_address jsonb,created_at timestamptz not null default now());
alter table public.profiles enable row level security;alter table public.products enable row level security;alter table public.product_images enable row level security;alter table public.site_content enable row level security;alter table public.orders enable row level security;
create policy "read active products" on public.products for select using(status='active' or exists(select 1 from public.profiles where id=auth.uid() and role='admin'));
create policy "admins manage products" on public.products for all using(exists(select 1 from public.profiles where id=auth.uid() and role='admin')) with check(exists(select 1 from public.profiles where id=auth.uid() and role='admin'));
create policy "read images" on public.product_images for select using(true);
create policy "admins manage images" on public.product_images for all using(exists(select 1 from public.profiles where id=auth.uid() and role='admin')) with check(exists(select 1 from public.profiles where id=auth.uid() and role='admin'));
create policy "read content" on public.site_content for select using(true);
create policy "admins manage content" on public.site_content for all using(exists(select 1 from public.profiles where id=auth.uid() and role='admin')) with check(exists(select 1 from public.profiles where id=auth.uid() and role='admin'));
create policy "read own profile" on public.profiles for select using(auth.uid()=id);
create policy "read own orders" on public.orders for select using(customer_id=auth.uid() or exists(select 1 from public.profiles where id=auth.uid() and role='admin'));
-- 建立管理員帳號後執行：
-- insert into public.profiles(id,role,display_name) values('AUTH_USER_UUID','admin','923 Store Owner');
