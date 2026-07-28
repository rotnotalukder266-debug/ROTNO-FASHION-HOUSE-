// ==========================================================
// এখানে আপনার Supabase প্রজেক্টের তথ্য বসান
// Supabase Dashboard > Project Settings > API থেকে পাবেন
// ==========================================================
const SUPABASE_URL = "YOUR_SUPABASE_PROJECT_URL"; // যেমন: https://xxxxx.supabase.co
const SUPABASE_ANON_KEY = "YOUR_SUPABASE_ANON_KEY";

const supabase = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
