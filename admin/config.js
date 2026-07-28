// ==========================================================
// Rotno Fashion House — Supabase কানেকশন তথ্য (রেডি করা আছে)
// ==========================================================
const SUPABASE_URL = "https://oxpabwkswhutnieckary.supabase.co";
const SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im94cGFid2tzd2h1dG5pZWNrYXJ5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODUxNDEwNjksImV4cCI6MjEwMDcxNzA2OX0.qsdQvdxA0We3-XBbc7Y8eZOOy-QEx1swL1KBmyC_gus";

const supabase = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
