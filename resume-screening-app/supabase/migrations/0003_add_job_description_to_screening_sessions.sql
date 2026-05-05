-- Add job_description column to screening_sessions table
ALTER TABLE public.screening_sessions ADD COLUMN job_description text NOT NULL DEFAULT '';
