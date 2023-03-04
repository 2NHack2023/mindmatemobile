import 'package:supabase/supabase.dart';

const supabaseUrl = 'https://drardmlngfenxvjiehkz.supabase.co/';
const supabaseKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRyYXJkbWxuZ2Zlbnh2amllaGt6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2Nzc5MzY4MzIsImV4cCI6MTk5MzUxMjgzMn0.R19AnPjm_66dXT2f_jOdUc4V2a5lk972Z5-L8kCRgEQ';

final supabaseClient = SupabaseClient(supabaseUrl, supabaseKey);
