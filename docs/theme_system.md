# E-sika Theme System

This document explains how to use the centralized theme system for the E-sika application. The theme is implemented using CSS variables and utility classes, without modifying the tailwind.config.js file.

## Dark Mode Support

The theme system includes built-in dark mode support. Users can toggle between light and dark modes using the theme toggle button in the header. The system respects the user's preference and stores it in a cookie for persistence across page loads.

## Overview

The theme system consists of:

1. **Theme Variables**: CSS variables defined in `app/assets/stylesheets/theme.css`
2. **Theme Utilities**: Utility classes in `app/assets/stylesheets/theme-utilities.css`
3. **Theme Components**: Component styles in `app/assets/stylesheets/theme-components.css`
4. **Theme Helpers**: Ruby helper methods in `app/helpers/theme_helper.rb`

## Using the Theme System

### 1. Theme Variables

Use CSS variables directly in your CSS for consistent styling:

```css
.my-element {
  color: rgb(var(--color-primary-500) / 1);
  font-size: var(--text-lg);
  padding: var(--spacing-4);
  border-radius: var(--radius-md);
  box-shadow: var(--shadow-md);
}
```

### 2. Theme Utility Classes

Use the provided utility classes in your HTML:

```html
<div class="text-primary-500 bg-secondary-100 p-4 rounded-lg shadow-md">
  Content with theme styling
</div>
```

### 3. Theme Component Classes

Use the predefined component classes:

```html
<button class="theme-btn theme-btn-primary">Primary Button</button>

<div class="theme-card">
  <div class="theme-card-header">Card Title</div>
  <div class="theme-card-body">Card content</div>
  <div class="theme-card-footer">
    <button class="theme-btn theme-btn-secondary">Action</button>
  </div>
</div>
```

### 4. Theme Helper Methods

Use the Ruby helper methods in your views:

```erb
<button class="<%= theme_button(:primary) %>">Primary Button</button>
<button class="<%= theme_button(:secondary, 'w-full mt-4') %>">Secondary Button</button>

<div class="<%= theme_card('mt-6') %>">
  <div class="theme-card-body">
    <p>Card content</p>
  </div>
</div>

<span class="<%= theme_badge(:success) %>">Success</span>

<div class="<%= theme_alert(:warning) %>">
  <strong>Warning:</strong> This is a warning message.
</div>
```

## Available Theme Variables

### Colors

- Primary: `--color-primary-[50-950]`
- Secondary: `--color-secondary-[50-950]`
- Accent: `--color-accent-[50-950]`
- Success: `--color-success-[50-950]`
- Warning: `--color-warning-[50-950]`
- Error: `--color-error-[50-950]`
- Gray: `--color-gray-[50-950]`

### Typography

- Font Families: `--font-sans`, `--font-serif`, `--font-mono`
- Font Sizes: `--text-xs` through `--text-6xl`

### Spacing

- Spacing: `--spacing-0` through `--spacing-32`

### Border Radius

- Border Radius: `--radius-none` through `--radius-full`

### Shadows

- Shadows: `--shadow-sm` through `--shadow-2xl`

### Transitions

- Transitions: `--transition-fast`, `--transition-normal`, `--transition-slow`

### Z-index

- Z-index: `--z-0` through `--z-50`, `--z-auto`

## Available Component Classes

### Buttons

- `theme-btn theme-btn-primary`
- `theme-btn theme-btn-secondary`
- `theme-btn theme-btn-accent`
- `theme-btn theme-btn-outline`
- `theme-btn theme-btn-ghost`

### Cards

- `theme-card`
- `theme-card-header`
- `theme-card-body`
- `theme-card-footer`

### Form Elements

- `theme-input`
- `theme-label`
- `theme-select`

### Badges

- `theme-badge theme-badge-primary`
- `theme-badge theme-badge-secondary`
- `theme-badge theme-badge-accent`
- `theme-badge theme-badge-success`
- `theme-badge theme-badge-warning`
- `theme-badge theme-badge-error`

### Alerts

- `theme-alert theme-alert-info`
- `theme-alert theme-alert-success`
- `theme-alert theme-alert-warning`
- `theme-alert theme-alert-error`

### Navigation

- `theme-nav`
- `theme-nav-item`
- `theme-nav-item-active`

## Customizing the Theme

To customize the theme, modify the CSS variables in `app/assets/stylesheets/theme.css`. All components and utilities will automatically reflect the changes.

### Dark Mode Customization

The theme system includes separate variables for dark mode. To customize the dark mode appearance:

1. Modify the variables in the `:root.dark` section of `app/assets/stylesheets/theme.css`
2. Use the `dark:` prefix with Tailwind classes to apply styles only in dark mode
3. Use the theme utility classes like `bg-theme-primary` and `text-theme-primary` which automatically adapt to the current theme

Example of dark mode specific styling:

```html
<div class="bg-white dark:bg-gray-800 text-black dark:text-white">
  This content adapts to dark mode
</div>
```

Or using theme utility classes:

```html
<div class="bg-theme-primary text-theme-primary">
  This content adapts to the current theme
</div>
```

## Example

Visit `/theme` in your browser to see a live demonstration of the theme system.
