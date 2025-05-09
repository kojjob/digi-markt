import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="theme-toggle"
export default class extends Controller {
  connect() {
    // Check for saved theme preference or respect OS preference
    if (this.getCookie('theme') === 'dark' ||
        (!this.getCookie('theme') &&
         window.matchMedia('(prefers-color-scheme: dark)').matches)) {
      this.enableDarkMode()
    } else {
      this.enableLightMode()
    }
  }

  toggle() {
    // Toggle the theme
    if (document.documentElement.classList.contains('dark')) {
      this.enableLightMode()
    } else {
      this.enableDarkMode()
    }
  }

  enableDarkMode() {
    document.documentElement.classList.add('dark')
    this.setCookie('theme', 'dark')
    // Force a redraw to ensure all styles are applied
    document.body.style.display = 'none'
    document.body.offsetHeight // This triggers a reflow
    document.body.style.display = ''
  }

  enableLightMode() {
    document.documentElement.classList.remove('dark')
    this.setCookie('theme', 'light')
    // Force a redraw to ensure all styles are applied
    document.body.style.display = 'none'
    document.body.offsetHeight // This triggers a reflow
    document.body.style.display = ''
  }

  // Helper method to get a cookie
  getCookie(name) {
    const value = `; ${document.cookie}`;
    const parts = value.split(`; ${name}=`);
    if (parts.length === 2) return parts.pop().split(';').shift();
  }

  // Helper method to set a cookie
  setCookie(name, value) {
    document.cookie = `${name}=${value}; path=/; max-age=31536000`; // 1 year
  }
}
