import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar"
export default class extends Controller {
  static targets = ["mobileMenu", "menuButton"]

  connect() {
    // Add scroll event listener to handle sticky behavior
    window.addEventListener('scroll', this.handleScroll.bind(this))

    // Initialize the navbar state
    this.handleScroll()

    // Close mobile menu when clicking outside
    document.addEventListener('click', this.handleOutsideClick.bind(this))
  }

  disconnect() {
    // Clean up event listeners
    window.removeEventListener('scroll', this.handleScroll.bind(this))
    document.removeEventListener('click', this.handleOutsideClick.bind(this))
  }

  handleScroll() {
    // Add shadow and background when scrolling down
    if (window.scrollY > 10) {
      this.element.classList.add('navbar-scrolled')
      this.element.classList.add('bg-opacity-95')
      this.element.classList.add('backdrop-blur-sm')
      this.element.classList.add('shadow-md')
    } else {
      this.element.classList.remove('navbar-scrolled')
      this.element.classList.remove('bg-opacity-95')
      this.element.classList.remove('backdrop-blur-sm')
      this.element.classList.remove('shadow-md')
    }
  }

  toggleMenu() {
    // Toggle mobile menu visibility with animation
    const mobileMenu = this.mobileMenuTarget
    const menuButton = this.menuButtonTarget

    if (mobileMenu.classList.contains('translate-x-full')) {
      // Open menu
      mobileMenu.classList.remove('translate-x-full')
      mobileMenu.classList.add('translate-x-0')

      // Change hamburger to X
      menuButton.classList.add('is-active')

      // Prevent body scrolling when menu is open
      document.body.style.overflow = 'hidden'
    } else {
      // Close menu
      this.closeMenu()
    }
  }

  closeMenu() {
    const mobileMenu = this.mobileMenuTarget
    const menuButton = this.menuButtonTarget

    // Close menu
    mobileMenu.classList.remove('translate-x-0')
    mobileMenu.classList.add('translate-x-full')

    // Change X back to hamburger
    menuButton.classList.remove('is-active')

    // Re-enable body scrolling
    document.body.style.overflow = ''
  }

  handleOutsideClick(event) {
    // Close menu when clicking outside
    const mobileMenu = this.mobileMenuTarget
    const menuButton = this.menuButtonTarget

    if (!mobileMenu.contains(event.target) &&
        !menuButton.contains(event.target) &&
        !mobileMenu.classList.contains('translate-x-full')) {
      this.closeMenu()
    }
  }
}
