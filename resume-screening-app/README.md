# Resume Screening System

A full-stack AI-powered resume screening application built with React, Supabase, and Tailwind CSS.

## Tech Stack

- **Frontend:** React 18, TypeScript, Tailwind CSS, shadcn/ui, Vite
- **Backend:** Supabase (PostgreSQL, Auth, Row Level Security)
- **Forms:** React Hook Form + Zod
- **Charts:** Recharts

## Project Structure

```
├── .rules/               # Code quality & linting rules (ast-grep)
├── src/                  # Frontend source code
├── supabase/
│   ├── migrations/       # Database migration files
│   └── config.toml       # Supabase configuration
├── package.json
├── tailwind.config.js
├── vite.config.ts
└── tsconfig.json
```

## Getting Started

### Prerequisites
- Node.js 18+
- pnpm
- A Supabase project

### Installation

```bash
# Install dependencies
pnpm install

# Start development server
npx vite --host 127.0.0.1
```

### Supabase Setup

1. Create a project at [supabase.com](https://supabase.com)
2. Run the migration files in order from `supabase/migrations/`
3. Add your Supabase URL and anon key to your environment variables

## Database Schema

- **profiles** — User accounts synced with Supabase Auth (roles: `user` | `admin`)
- **screening_sessions** — Each resume screening job with a job description
- **screening_results** — Individual candidate results with scores, skills, and rankings

## User Roles

- **Admin** — First registered user; has full access to all data
- **User** — Can only view and manage their own screening sessions
