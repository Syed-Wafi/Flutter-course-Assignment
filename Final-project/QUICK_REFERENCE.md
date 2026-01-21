# Quick Reference Guide - Supabase Integration

## 🚀 Getting Started (5 Minutes)

### 1. Install & Run

```bash
cd mess_manager_final
flutter pub get
flutter run
```

### 2. Database Setup (See SUPABASE_SETUP.md for complete guide)

**In Supabase Dashboard → SQL Editor, run:**

```sql
-- Users Profile Table
CREATE TABLE user_profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Members Table
CREATE TABLE members (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Meals Table
CREATE TABLE meals (
  id UUID PRIMARY KEY,
  member_id UUID NOT NULL REFERENCES members(id),
  user_id UUID NOT NULL REFERENCES auth.users(id),
  count INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Expenses Table
CREATE TABLE expenses (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id),
  title TEXT NOT NULL,
  amount DECIMAL(10, 2) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 3. Enable RLS

For each table:

- Go to Table → Settings → Row Level Security
- Click "Enable RLS"
- Add policies (see SUPABASE_SETUP.md)

### 4. Test the App

- Sign up with test email
- Add members, meals, expenses
- View summary
- Logout and login to verify persistence

---

## 📱 App Navigation

```
Login Screen
    ↓
[Sign Up] ← → [Login]
              ↓
            Dashboard
            ↓
    ├→ Members (Add/Edit/Delete)
    ├→ Meals (Add/Edit/Delete)
    ├→ Expenses (Add/Edit/Delete)
    └→ Summary (View calculations)

[Logout] → Back to Login
```

---

## 🔧 Key Services

### AuthService

```dart
// Sign up
await AuthService().signUp(
  email: 'user@example.com',
  password: 'password123',
  fullName: 'User Name',
);

// Login
await AuthService().login(
  email: 'user@example.com',
  password: 'password123',
);

// Logout
await AuthService().logout();

// Get current user
User? user = AuthService().currentUser;

// Listen to auth state
AuthService().authStateStream.listen((event) {
  // Handle auth state changes
});
```

### DatabaseService

```dart
final db = DatabaseService();

// Members
await db.addMember(Member(name: 'Ali'));
List<Member> members = await db.getMembers();
await db.updateMember(id, 'New Name');
await db.deleteMember(id);

// Meals
await db.addMeal(Meal(memberId: 'id', count: 5));
List<Meal> meals = await db.getMeals();
await db.updateMeal(id, 10);
await db.deleteMeal(id);

// Expenses
await db.addExpense(Expense(title: 'Rent', amount: 5000));
List<Expense> expenses = await db.getExpenses();
await db.updateExpense(id, Expense(...));
await db.deleteExpense(id);
```

---

## 📊 Database Schema

### user_profiles

```
id (UUID, PK)
full_name (TEXT)
created_at (TIMESTAMP)
updated_at (TIMESTAMP)
```

### members

```
id (UUID, PK)
user_id (UUID, FK → auth.users)
name (TEXT)
created_at (TIMESTAMP)
updated_at (TIMESTAMP)
```

### meals

```
id (UUID, PK)
member_id (UUID, FK → members)
user_id (UUID, FK → auth.users)
count (INT)
created_at (TIMESTAMP)
updated_at (TIMESTAMP)
```

### expenses

```
id (UUID, PK)
user_id (UUID, FK → auth.users)
title (TEXT)
amount (DECIMAL)
created_at (TIMESTAMP)
updated_at (TIMESTAMP)
```

---

## 🔐 Security Quick Checklist

- [ ] RLS enabled on all tables
- [ ] RLS policies created (see SUPABASE_SETUP.md)
- [ ] user_id field in all tables (except user_profiles)
- [ ] Foreign keys created
- [ ] Indexes created for performance

---

## 🐛 Troubleshooting

| Error                         | Solution                                   |
| ----------------------------- | ------------------------------------------ |
| "Invalid Credentials"         | Check email/password, create account first |
| "Relation does not exist"     | Run SQL setup from SUPABASE_SETUP.md       |
| "Permission denied"           | Enable RLS and add policies correctly      |
| "No data showing"             | Check RLS policies allow SELECT            |
| "Can't add member"            | Check RLS policies allow INSERT            |
| "Can't see other user's data" | This is correct! RLS is working            |

---

## 📝 Model Quick Reference

### Member

```dart
Member(
  id: 'uuid-string', // Optional, auto-generated
  name: 'Member Name',
)
```

### Meal

```dart
Meal(
  id: 'uuid-string', // Optional, auto-generated
  memberId: 'member-uuid',
  count: 5,
)
```

### Expense

```dart
Expense(
  id: 'uuid-string', // Optional, auto-generated
  title: 'Expense Title',
  amount: 5000.0,
)
```

---

## 🎨 Screen Quick Reference

### LoginPage

- Email input
- Password input
- Login button
- Signup navigation

### SignupPage

- Full name input
- Email input
- Password input
- Confirm password input
- Signup button
- Login navigation

### Dashboard

- Members card → MemberPage
- Meals card → MealPage
- Expenses card → ExpensePage
- Summary card → SummaryPage
- Logout button (top right)

### MemberPage

- List of members
- Add button
- Edit (inline)
- Delete (inline)

### MealPage

- List of meals with member names
- Add button
- Delete button

### ExpensePage

- List of expenses
- Add button
- Edit (dialog)
- Delete (inline)

### SummaryPage

- Total meals card
- Total expenses card
- Meal rate card
- Member bills list

---

## 📱 Android/iOS Setup (Optional)

### Android

```yaml
# android/app/build.gradle
defaultConfig {
minSdkVersion 21
}
```

### iOS

No additional setup needed for basic functionality.

---

## 🚢 Production Checklist

- [ ] Test all features thoroughly
- [ ] Verify data isolation (multiple users)
- [ ] Check error messages are user-friendly
- [ ] Test with different network conditions
- [ ] Verify RLS policies are correct
- [ ] Update Supabase credentials if needed
- [ ] Set up backups in Supabase
- [ ] Monitor usage and quotas
- [ ] Test logout functionality
- [ ] Verify session persistence

---

## 📚 File Locations

| Feature       | File                                 |
| ------------- | ------------------------------------ |
| Auth          | `lib/services/auth_service.dart`     |
| Database      | `lib/services/database_service.dart` |
| Login UI      | `lib/screens/login_page.dart`        |
| Signup UI     | `lib/screens/signup_page.dart`       |
| Dashboard     | `lib/screens/dashboard.dart`         |
| Members       | `lib/screens/member_page.dart`       |
| Meals         | `lib/screens/meal_page.dart`         |
| Expenses      | `lib/screens/expense_page.dart`      |
| Summary       | `lib/screens/summary_page.dart`      |
| Member Model  | `lib/models/member.dart`             |
| Meal Model    | `lib/models/meal.dart`               |
| Expense Model | `lib/models/expense.dart`            |
| Calculations  | `lib/utils/calculation.dart`         |
| Main          | `lib/main.dart`                      |

---

## 💡 Pro Tips

1. **Use Supabase Dashboard** for monitoring:

   - Go to Logs → API to see all requests
   - Monitor database performance
   - Check RLS policies execution

2. **Testing Multiple Users**:

   - Sign up with different emails
   - Verify data isolation
   - Each user should only see their data

3. **Error Handling**:

   - All errors show SnackBars to users
   - Check console for detailed error logs
   - Use Supabase logs for backend issues

4. **Performance**:

   - Indexes help with large datasets
   - RLS can impact query performance
   - Monitor with Supabase metrics

5. **Development**:
   - Use Supabase local development (optional)
   - Test auth flow thoroughly
   - Clear app cache when testing

---

## 🎓 Learning Path

1. **Understand the flow**: Read INTEGRATION_COMPLETE.md
2. **Set up database**: Follow SUPABASE_SETUP.md
3. **Run the app**: `flutter run`
4. **Test features**: Create account, add data, verify
5. **Explore code**: Read the service implementations
6. **Deploy**: Follow deployment notes in IMPLEMENTATION_REPORT.md

---

## 📞 Quick Links

- **Supabase Dashboard**: https://supabase.com/dashboard
- **Project URL**: https://deirwwqwcxldsavpbyla.supabase.co
- **Documentation**: https://supabase.com/docs
- **Flutter Docs**: https://flutter.dev/docs

---

**Last Updated**: January 5, 2026  
**Status**: ✅ Ready for Use
