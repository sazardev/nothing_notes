# Nothing Notes — Todo App Specification

## 1. Concept & Vision

A minimal, offline-first todo application inspired by Nothing's industrial design language. The app embodies the philosophy of "subtract, don't add" — every element earns its pixel. It's a personal task manager that feels like an instrument panel: precise, purposeful, and quietly confident. No accounts, no cloud, no noise — just your tasks, secured locally.

**Core feeling:** An OLED instrument panel in a dark room. Tasks glow on the black canvas. Data as beauty.

---

## 2. Design Language

### 2.1 Fonts (Google Fonts — declare before use)

| Role | Font | Fallback | Weights |
|------|------|----------|---------|
| Display/Hero | `Doto` | `Space Mono, monospace` | 400–700 |
| Body/UI | `Space Grotesk` | `DM Sans, system-ui` | Light 300, Regular 400, Medium 500 |
| Data/Labels | `Space Mono` | `JetBrains Mono, SF Mono` | Regular 400, Bold 700 |

### 2.2 Color Palette

**Dark Mode (Primary — OLED black)**
| Token | Hex | Role |
|-------|-----|------|
| `--black` | `#000000` | Primary background |
| `--surface` | `#111111` | Cards, elevated surfaces |
| `--surface-raised` | `#1A1A1A` | Secondary elevation |
| `--border` | `#222222` | Subtle dividers |
| `--border-visible` | `#333333` | Intentional borders |
| `--text-disabled` | `#666666` | Disabled text |
| `--text-secondary` | `#999999` | Labels, metadata |
| `--text-primary` | `#E8E8E8` | Body text |
| `--text-display` | `#FFFFFF` | Headlines, hero numbers |
| `--accent` | `#D71921` | Active states, destructive |
| `--success` | `#4A9E5C` | Completed tasks |
| `--warning` | `#D4A843` | Pending, attention |

**Light Mode**
| Token | Hex |
|-------|-----|
| `--black` | `#F5F5F5` |
| `--surface` | `#FFFFFF` |
| `--surface-raised` | `#F0F0F0` |
| `--border` | `#E8E8E8` |
| `--border-visible` | `#CCCCCC` |
| `--text-disabled` | `#999999` |
| `--text-secondary` | `#666666` |
| `--text-primary` | `#1A1A1A` |
| `--text-display` | `#000000` |

### 2.3 Typography Scale

| Token | Size | Line Height | Letter Spacing | Use |
|-------|------|-------------|----------------|-----|
| `--display-lg` | 48px | 1.05 | -0.02em | Hero task count |
| `--display-md` | 36px | 1.1 | -0.02em | Page titles |
| `--heading` | 24px | 1.2 | -0.01em | Section headings |
| `--body` | 16px | 1.5 | 0 | Body text |
| `--body-sm` | 14px | 1.5 | 0.01em | Secondary body |
| `--caption` | 12px | 1.4 | 0.04em | Timestamps |
| `--label` | 11px | 1.2 | 0.08em | ALL CAPS labels |

### 2.4 Spacing System (8px base)

| Token | Value |
|-------|-------|
| `--space-2xs` | 2px |
| `--space-xs` | 4px |
| `--space-sm` | 8px |
| `--space-md` | 16px |
| `--space-lg` | 24px |
| `--space-xl` | 32px |
| `--space-2xl` | 48px |
| `--space-3xl` | 64px |
| `--space-4xl` | 96px |

### 2.5 Motion

- Duration: 150–250ms micro, 300–400ms transitions
- Easing: `cubic-bezier(0.25, 0.1, 0.25, 1)` — subtle ease-out
- Opacity transitions preferred over position
- No spring/bounce, no parallax

### 2.6 Visual Rules

- **Three-layer hierarchy only:** Display (hero) > Primary (body) > Tertiary (metadata)
- **No shadows, no gradients in UI chrome**
- **No border-radius > 16px on cards, buttons are pill (999px) or technical (4–8px)**
- **Monochrome base, color as event (accent red for urgent/destructive)**
- **Dot-matrix motif for decorative/empty states**

---

## 3. Layout & Structure

### 3.1 Screen Architecture

**1. Home Screen (Tasks List)**
- Hero: Task count in `Doto` 48px (`--display-lg`)
- Filter bar: [ALL] [TODAY] [UPCOMING] [COMPLETED] — segmented control
- Task list: Vertical scrolling, dividers between items
- FAB: Add new task (pill button, bottom-right on mobile)

**2. Task Detail / Add Screen**
- Back button: Circular, top-left
- Title: Large input or display
- Due date: Date picker (linear stepping, no calendar popup)
- Priority: Segmented control [LOW] [MEDIUM] [HIGH]
- Notes: Multi-line text area
- Actions: Save / Delete

**3. Settings Screen**
- Theme toggle: Dark / Light (pill segmented)
- About section

### 3.2 Responsive Breakpoints

| Breakpoint | Width | Layout |
|------------|-------|--------|
| Mobile | < 600px | Single column, bottom nav |
| Tablet | 600–1024px | Single column, side rail nav |
| Desktop | > 1024px | Two-column (list + detail), horizontal nav |

### 3.3 Navigation

- **Mobile:** Bottom navigation bar with 3 items: Tasks, Calendar (future), Settings
- **Desktop:** Horizontal top bar `TASKS | SETTINGS` with bracket notation
- **Back button:** Circular 40px, `--surface` bg, chevron `<`

---

## 4. Features & Interactions

### 4.1 Core Features

1. **Create Task**
   - Tap FAB → Add Task screen
   - Fields: Title (required), Due date (optional), Priority (default: MEDIUM), Notes (optional)
   - Save: Validates title not empty, persists to SQLite via Drift
   - Cancel: Discard with confirmation if dirty

2. **View Tasks**
   - Home screen shows all tasks grouped by filter
   - Each row: Checkbox left, Title center, Due date right
   - Completed: Checkbox filled, text `--text-disabled`, strikethrough
   - Tap row → Task Detail screen

3. **Complete/Uncomplete Task**
   - Tap checkbox → Toggle completion state
   - Completed tasks can be filtered via segmented control
   - Visual: Checkbox fills with `--success` green, text fades

4. **Edit Task**
   - From detail screen, edit any field
   - Save updates SQLite record
   - Delete removes with confirmation dialog

5. **Filter Tasks**
   - ALL: All tasks regardless of state
   - TODAY: Tasks due today (match against date only)
   - UPCOMING: Tasks due in next 7 days
   - COMPLETED: Tasks where completed = true

6. **Theme Toggle**
   - Settings screen: Dark/Light segmented control
   - Persists preference to SharedPreferences
   - Instant switch, no restart

### 4.2 Interactions

| Element | Interaction | Result |
|---------|-------------|--------|
| Task checkbox | Tap | Toggle completion with 200ms fade |
| Task row | Tap | Navigate to detail |
| FAB | Tap | Navigate to add task |
| Back button | Tap | Pop screen, confirm if dirty |
| Save button | Tap | Validate & persist |
| Delete button | Tap | Show confirmation dialog |
| Filter segment | Tap | Filter list instantly |
| Theme toggle | Tap | Switch theme immediately |

### 4.3 States

- **Empty state:** Centered text `--text-secondary`, 1 sentence, dot-grid background optional
- **Loading:** `[LOADING...]` in Space Mono, centered
- **Error:** Inline `[ERROR: message]` in `--accent`, no popups

---

## 5. Component Inventory

### 5.1 Buttons

| Variant | Background | Border | Text | Radius |
|---------|-----------|--------|------|--------|
| Primary | `--text-display` | none | `--black` | 999px |
| Secondary | transparent | 1px `--border-visible` | `--text-primary` | 999px |
| Ghost | transparent | none | `--text-secondary` | 0 |
| Destructive | transparent | 1px `--accent` | `--accent` | 999px |

All buttons: `Space Mono`, 13px, ALL CAPS, letter-spacing 0.06em, padding 12px 24px, min-height 44px.

### 5.2 Task Row

- Container: `--surface` background, full-width divider below
- Left: Custom circular checkbox (24px, 2px border, filled = `--success`)
- Center: Task title in `--body`, `--text-primary` or `--text-disabled` if completed
- Right: Due date in `--caption`, `--text-secondary`, or `--accent` if overdue
- Min-height: 56px, padding 16px horizontal

### 5.3 Segmented Control

- Container: 1px `--border-visible`, pill or 8px radius
- Active: `--text-display` bg, `--black` text
- Inactive: transparent, `--text-secondary`
- Text: Space Mono, ALL CAPS, `--label` size
- Height: 36–44px

### 5.4 Input Fields

- Underline style: 1px `--border-visible` bottom
- Focus: border → `--text-primary`
- Label above: `--label` style, Space Mono, ALL CAPS
- Error: border → `--accent`, error message below

### 5.5 Date Picker

- Linear stepping: `< LABEL >` format
- Label: Space Mono, ALL CAPS
- Arrows: thin chevrons, `--text-secondary`, 44px touch targets

### 5.6 Dialog/Modal

- Backdrop: `rgba(0,0,0,0.8)`
- Dialog: `--surface` bg, 1px `--border-visible`, 16px radius, max 400px
- Close: `[ X ]` ghost button top-right

### 5.7 Navigation Bar (Bottom)

- Background: `--surface`
- Items: Icon + label, Space Mono caps
- Active: `--text-display` + dot indicator
- Inactive: `--text-disabled`
- Height: 64px, safe area padding

### 5.7 Navigation Bar (Top Desktop)

- Background: `--black` (dark) / `--surface` (light)
- Items: `TASKS  |  SETTINGS` bracket notation
- Active: `--text-display`
- Inactive: `--text-disabled`

---

## 6. Technical Approach

### 6.1 Stack

| Layer | Technology |
|-------|------------|
| Framework | Flutter 3.12+ |
| State Management | Riverpod (flutter_riverpod) |
| Database | SQLite via Drift (drift, drift_flutter) |
| Local Storage | SharedPreferences (theme preference) |
| Routing | GoRouter |
| Target Platforms | Android, Linux, Web |

### 6.2 Project Structure

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── colors.dart
│   │   └── typography.dart
│   ├── router/
│   │   └── app_router.dart
│   └── constants.dart
├── data/
│   ├── database/
│   │   ├── app_database.dart
│   │   └── tables/
│   │       └── tasks_table.dart
│   └── repositories/
│       └── task_repository.dart
├── domain/
│   └── models/
│       └── task.dart
├── presentation/
│   ├── providers/
│   │   ├── tasks_provider.dart
│   │   ├── filter_provider.dart
│   │   └── theme_provider.dart
│   ├── screens/
│   │   ├── home/
│   │   │   └── home_screen.dart
│   │   ├── task_detail/
│   │   │   └── task_detail_screen.dart
│   │   └── settings/
│   │       └── settings_screen.dart
│   └── widgets/
│       ├── task_row.dart
│       ├── segmented_filter.dart
│       ├── nothing_button.dart
│       └── nothing_input.dart
```

### 6.3 Data Model

```dart
class Task {
  final int id;
  final String title;
  final String? notes;
  final DateTime? dueDate;
  final Priority priority; // low, medium, high
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;
}

enum Priority { low, medium, high }
```

### 6.4 Database Schema (Drift)

```sql
CREATE TABLE tasks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  notes TEXT,
  due_date INTEGER, -- Unix timestamp
  priority INTEGER NOT NULL DEFAULT 1, -- 0=low, 1=medium, 2=high
  is_completed INTEGER NOT NULL DEFAULT 0,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);
```

### 6.5 API / Data Flow

```
Widget → Provider (watch/read) → Repository → Database
         ↑ Provider (notifier) ← Repository (CRUD)
```

### 6.6 Security

- All data stored locally in app-private SQLite database
- No network permissions requested
- No analytics, no telemetry
- Database stored in platform-specific app documents directory

### 6.7 Responsive Implementation

- Use `LayoutBuilder` and `MediaQuery` for breakpoints
- Mobile: Single column, bottom nav
- Desktop: Master-detail two-column layout
- Breakpoint constants in `core/constants.dart`

---

## 7. Platform-Specific Considerations

### Android
- Handle back button via `PopScope`
- Respect system navigation bar and status bar colors
- Use `android:windowBackground` for splash consistency

### Linux
- Support window resizing with minimum size 400x600
- GTK theme integration optional
- Keyboard shortcuts: Ctrl+N (new task), Ctrl+S (save), Escape (back)

### Web
- PWA manifest with app name and icons
- Service worker for offline capability
- URL-based routing via GoRouter
- Responsive meta viewport

---

## 8. Future Considerations (Out of Scope)

- Cloud sync
- User accounts
- Notifications/reminders
- Recurring tasks
- Tags/categories
- Collaboration
- Widgets (home screen)

---

## 9. Milestones

1. **Foundation:** Project setup, Drift database, basic CRUD
2. **UI Shell:** Theme system, navigation, responsive layout
3. **Home Screen:** Task list, filters, completion toggle
4. **Task Detail:** Add/edit/delete task
5. **Polish:** Animations, empty states, error handling
6. **Platforms:** Android build, Linux build, Web build
