# Mess Management System - Supabase Integration Guide

## Database Schema Setup

To complete the Supabase integration, you need to create the following tables and set up Row Level Security (RLS) policies.

### Tables to Create in Supabase

#### 1. user_profiles Table

```sql
CREATE TABLE user_profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### 2. members Table

```sql
CREATE TABLE members (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### 3. meals Table

```sql
CREATE TABLE meals (
  id UUID PRIMARY KEY,
  member_id UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  count INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### 4. expenses Table

```sql
CREATE TABLE expenses (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  amount DECIMAL(10, 2) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Row Level Security (RLS) Policies

Enable RLS on all tables and create the following policies:

#### user_profiles RLS:

```sql
-- View own profile
CREATE POLICY "Users can view own profile"
  ON user_profiles FOR SELECT
  USING (auth.uid() = id);

-- Update own profile
CREATE POLICY "Users can update own profile"
  ON user_profiles FOR UPDATE
  USING (auth.uid() = id);

-- Insert own profile
CREATE POLICY "Users can insert own profile"
  ON user_profiles FOR INSERT
  WITH CHECK (auth.uid() = id);
```

#### members RLS:

```sql
-- View own members
CREATE POLICY "Users can view own members"
  ON members FOR SELECT
  USING (user_id = auth.uid());

-- Insert own members
CREATE POLICY "Users can insert members"
  ON members FOR INSERT
  WITH CHECK (user_id = auth.uid());

-- Update own members
CREATE POLICY "Users can update own members"
  ON members FOR UPDATE
  USING (user_id = auth.uid());

-- Delete own members
CREATE POLICY "Users can delete own members"
  ON members FOR DELETE
  USING (user_id = auth.uid());
```

#### meals RLS:

```sql
-- View own meals
CREATE POLICY "Users can view own meals"
  ON meals FOR SELECT
  USING (user_id = auth.uid());

-- Insert own meals
CREATE POLICY "Users can insert meals"
  ON meals FOR INSERT
  WITH CHECK (user_id = auth.uid());

-- Update own meals
CREATE POLICY "Users can update own meals"
  ON meals FOR UPDATE
  USING (user_id = auth.uid());

-- Delete own meals
CREATE POLICY "Users can delete own meals"
  ON meals FOR DELETE
  USING (user_id = auth.uid());
```

#### expenses RLS:

```sql
-- View own expenses
CREATE POLICY "Users can view own expenses"
  ON expenses FOR SELECT
  USING (user_id = auth.uid());

-- Insert own expenses
CREATE POLICY "Users can insert expenses"
  ON expenses FOR INSERT
  WITH CHECK (user_id = auth.uid());

-- Update own expenses
CREATE POLICY "Users can update own expenses"
  ON expenses FOR UPDATE
  USING (user_id = auth.uid());

-- Delete own expenses
CREATE POLICY "Users can delete own expenses"
  ON expenses FOR DELETE
  USING (user_id = auth.uid());
```

### Database Indexes (Optional but Recommended)

```sql
-- Create indexes for better query performance
CREATE INDEX idx_members_user_id ON members(user_id);
CREATE INDEX idx_meals_user_id ON meals(user_id);
CREATE INDEX idx_meals_member_id ON meals(member_id);
CREATE INDEX idx_expenses_user_id ON expenses(user_id);
```

## Steps to Set Up

1. **Go to Supabase Dashboard**: https://supabase.com/dashboard
2. **Select Your Project**: Navigate to your project
3. **Open SQL Editor**: Go to SQL Editor
4. **Run the Setup Scripts**:
   - Copy and run each table creation SQL above
   - Enable RLS on each table (Table settings → Row Level Security)
   - Copy and run each RLS policy SQL above
   - (Optional) Run the indexes creation SQL

## Authentication Features

The app includes:

- **Sign Up**: New users can create an account with email and password
- **Login**: Existing users can log in
- **Logout**: Users can securely log out
- **Session Management**: Automatic session handling with Supabase

## API Key Security

**Important**: The API key used is a publishable key (suitable for client-side code). For production:

- Keep API keys secure
- Use Row Level Security (RLS) to protect data
- Consider using a service role key for backend operations
- Implement proper authentication and authorization

## Services Overview

### AuthService (`lib/services/auth_service.dart`)

- Sign up with email, password, and full name
- Login with credentials
- Logout functionality
- Session management
- Stream-based authentication state monitoring

### DatabaseService (`lib/services/database_service.dart`)

- CRUD operations for Members
- CRUD operations for Meals
- CRUD operations for Expenses
- User-scoped data (all operations filter by user_id)

## Running the App

```bash
flutter pub get
flutter run
```

The app will:

1. Start at the login screen if not authenticated
2. Show the dashboard after successful login
3. All data is automatically stored in Supabase
4. Logout clears the session and returns to login

## Features

✅ Complete Authentication System (Sign Up, Login, Logout)
✅ Secure Data Storage with RLS
✅ Real-time Data Sync
✅ User-specific Data Isolation
✅ Full CRUD Operations
✅ Session Management
✅ Error Handling
✅ Loading States
✅ User Feedback (SnackBars)

## Testing

1. Create an account with your email
2. Add some members
3. Add meals for members
4. Add expenses
5. View the summary with calculated meal rates
6. Logout and login with the same account to verify data persistence

## Troubleshooting

- **Auth errors**: Check that email/password are correct
- **Database errors**: Verify RLS policies are set up correctly
- **Network errors**: Ensure internet connection is active
- **Session errors**: Clear app cache and try again
