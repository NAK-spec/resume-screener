-- Enable RLS on all tables
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.screening_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.screening_results ENABLE ROW LEVEL SECURITY;

-- Create helper function to check if user is admin
CREATE OR REPLACE FUNCTION has_role(uid uuid, role_name text)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM profiles p
    WHERE p.id = uid AND p.role = role_name::user_role
  );
$$;

-- Profiles policies
CREATE POLICY "Admins have full access to profiles" ON profiles
  FOR ALL TO authenticated USING (has_role(auth.uid(), 'admin'));

CREATE POLICY "Users can view their own profile" ON profiles
  FOR SELECT TO authenticated USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile except role" ON profiles
  FOR UPDATE TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id AND role = (SELECT role FROM profiles WHERE id = auth.uid()));

-- Screening sessions policies
CREATE POLICY "Users can view their own screening sessions" ON screening_sessions
  FOR SELECT TO authenticated USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own screening sessions" ON screening_sessions
  FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Admins can view all screening sessions" ON screening_sessions
  FOR SELECT TO authenticated USING (has_role(auth.uid(), 'admin'));

-- Screening results policies
CREATE POLICY "Users can view their own screening results" ON screening_results
  FOR SELECT TO authenticated USING (
    EXISTS (
      SELECT 1 FROM screening_sessions
      WHERE screening_sessions.id = screening_results.session_id
      AND screening_sessions.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can insert their own screening results" ON screening_results
  FOR INSERT TO authenticated WITH CHECK (
    EXISTS (
      SELECT 1 FROM screening_sessions
      WHERE screening_sessions.id = screening_results.session_id
      AND screening_sessions.user_id = auth.uid()
    )
  );

CREATE POLICY "Admins can view all screening results" ON screening_results
  FOR SELECT TO authenticated USING (has_role(auth.uid(), 'admin'));

-- Create public_profiles view for shareable info
CREATE VIEW public_profiles AS
  SELECT id, email, role, created_at FROM profiles;
