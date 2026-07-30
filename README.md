# 923 Commerce V1

這是 923 正式網站的第一個可持續開發版本。

## 已完成
- 顧客前台 `/`
- 顧客登入 `/login`
- 顧客會員中心 `/account`
- 獨立店家登入 `/admin/login`
- 受保護店家後台 `/admin`
- 中英文切換
- Supabase Auth 與 customer/admin 角色驗證
- 商品、商品多圖、內容與訂單資料表
- RLS 權限政策
- Netlify 部署設定
- 後台建立中英文商品草稿

## 啟動
```bash
npm install
npm run dev
```

## Supabase 設定
1. 建立 Supabase Project。
2. 在 SQL Editor 執行 `supabase/schema.sql`。
3. 在 Authentication 建立店家帳號。
4. 複製店家 UUID，執行：
```sql
insert into public.profiles(id,role,display_name)
values('店家 UUID','admin','923 Store Owner');
```
5. 複製 `.env.example` 為 `.env`，填入 Project URL 與 anon key。

## Netlify
- Build command：`npm run build`
- Publish directory：`dist`
- Environment variables：`VITE_SUPABASE_URL`、`VITE_SUPABASE_ANON_KEY`

## 下一階段
商品圖片上傳、商品修改與上下架、尺寸顏色、購物車、正式訂單、首頁 CMS、品牌故事 CMS、網站配色、金流與物流。
