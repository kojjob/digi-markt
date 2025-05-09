import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tutorials--tutorial"
export default class extends Controller {
  static targets = [
    "categoryPill", 
    "tutorialCard", 
    "feedbackBtn", 
    "feedbackForm",
    "copyLinkBtn",
    "linkInput",
    "searchInput",
    "progressBar"
  ]

  connect() {
    console.log("Tutorial controller connected")
    this.initializeObserver()
    this.updateProgressBar()
  }

  // Category filtering with animation
  filterCategory(event) {
    event.preventDefault()
    
    const clickedPill = event.currentTarget
    const category = clickedPill.dataset.category
    
    // Update active pill state
    this.categoryPillTargets.forEach(pill => {
      pill.classList.remove('active')
    })
    clickedPill.classList.add('active')
    
    // Animate tutorial cards based on category
    this.tutorialCardTargets.forEach(card => {
      // Initial fade out
      card.style.opacity = '0'
      card.style.transform = 'translateY(20px)'
      card.style.transition = 'opacity 300ms, transform 300ms'
      
      setTimeout(() => {
        if (category === 'all') {
          card.style.display = 'block'
          setTimeout(() => {
            card.style.opacity = '1'
            card.style.transform = 'translateY(0)'
          }, 50)
        } else {
          const cardCategories = card.dataset.categories.split(' ')
          if (cardCategories.includes(category)) {
            card.style.display = 'block'
            setTimeout(() => {
              card.style.opacity = '1'
              card.style.transform = 'translateY(0)'
            }, 50)
          } else {
            card.style.display = 'none'
          }
        }
      }, 300)
    })
  }

  // Feedback form toggle
  toggleFeedback(event) {
    const clickedBtn = event.currentTarget
    
    // Toggle form visibility
    this.feedbackFormTarget.classList.toggle('hidden')
    
    // Update active state on buttons
    this.feedbackBtnTargets.forEach(btn => {
      btn.classList.remove('active')
    })
    clickedBtn.classList.add('active')
  }

  // Copy link to clipboard
  copyLink(event) {
    event.preventDefault()
    const button = event.currentTarget
    const originalText = button.innerHTML
    
    // Copy text to clipboard
    const linkText = this.linkInputTarget.value
    navigator.clipboard.writeText(linkText)
      .then(() => {
        // Show success state
        button.innerHTML = `
          <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
          </svg>
          Copied!
        `
        
        // Reset after 2 seconds
        setTimeout(() => {
          button.innerHTML = originalText
        }, 2000)
      })
      .catch(err => {
        console.error('Failed to copy: ', err)
        
        // Show error state
        button.innerHTML = `
          <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
          </svg>
          Failed!
        `
        
        // Reset after 2 seconds
        setTimeout(() => {
          button.innerHTML = originalText
        }, 2000)
      })
  }

  // Handle search keyboard shortcut (⌘+K)
  initSearchShortcut() {
    document.addEventListener('keydown', (e) => {
      // Check for cmd/ctrl + K
      if ((e.metaKey || e.ctrlKey) && e.key === 'k') {
        e.preventDefault()
        this.searchInputTarget.focus()
      }
    })
  }

  // Smooth scroll to tutorial steps
  scrollToStep(event) {
    event.preventDefault()
    
    const targetId = event.currentTarget.getAttribute('href')
    const targetElement = document.querySelector(targetId)
    
    if (targetElement) {
      window.scrollTo({
        top: targetElement.offsetTop - 100,
        behavior: 'smooth'
      })
    }
  }

  // Initialize intersection observer for animations and progress tracking
  initializeObserver() {
    if ('IntersectionObserver' in window) {
      // Animate tutorial steps when they become visible
      const stepsObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
          if (entry.isIntersecting) {
            entry.target.classList.add('animate-fade-in')
            stepsObserver.unobserve(entry.target)
          }
        })
      }, {
        threshold: 0.2
      })
      
      // Observe tutorial steps
      document.querySelectorAll('.tutorial-step').forEach(step => {
        stepsObserver.observe(step)
      })
    }
  }

  // Update progress bar based on scroll position
  updateProgressBar() {
    if (!this.hasProgressBarTarget) return
    
    const updateProgress = () => {
      const totalHeight = document.body.scrollHeight - window.innerHeight
      const progress = (window.scrollY / totalHeight) * 100
      this.progressBarTarget.style.width = `${Math.min(progress, 100)}%`
    }
    
    window.addEventListener('scroll', updateProgress)
    updateProgress() // Initial call
  }

  // Mark tutorial as complete
  markAsComplete(event) {
    event.preventDefault()
    
    const button = event.currentTarget
    const originalText = button.innerHTML
    
    // Show loading state
    button.innerHTML = `
      <svg class="animate-spin h-5 w-5 mr-2" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
      </svg>
      Saving...
    `
    
    // Simulate API request (replace with actual API call)
    setTimeout(() => {
      // Show completion state
      button.innerHTML = `
        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
        </svg>
        Completed!
      `
      
      // Update progress bar to 100%
      if (this.hasProgressBarTarget) {
        this.progressBarTarget.style.width = '100%'
      }
      
      // Optional: Add a completion class to body or container
      document.body.classList.add('tutorial-completed')
    }, 1000)
  }
  
  // Toggle image zoom
  toggleImageZoom(event) {
    const image = event.currentTarget.closest('.tutorial-step').querySelector('img')
    
    if (!document.querySelector('.zoom-overlay')) {
      // Create overlay
      const overlay = document.createElement('div')
      overlay.className = 'fixed inset-0 bg-black/80 flex items-center justify-center z-50 zoom-overlay'
      
      // Create zoomed image
      const zoomedImg = document.createElement('img')
      zoomedImg.src = image.src
      zoomedImg.className = 'max-h-[90vh] max-w-[90vw] object-contain'
      
      // Close button
      const closeBtn = document.createElement('button')
      closeBtn.className = 'absolute top-4 right-4 bg-white/20 hover:bg-white/40 text-white p-2 rounded-full transition-colors'
      closeBtn.innerHTML = `
        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
        </svg>
      `
      
      // Close on click
      overlay.addEventListener('click', () => {
        document.body.removeChild(overlay)
        document.body.style.overflow = 'auto'
      })
      
      // Prevent image click from closing
      zoomedImg.addEventListener('click', (e) => {
        e.stopPropagation()
      })
      
      // Add elements to overlay
      overlay.appendChild(zoomedImg)
      overlay.appendChild(closeBtn)
      
      // Add to body
      document.body.appendChild(overlay)
      document.body.style.overflow = 'hidden'
    } else {
      // Remove overlay if exists
      const overlay = document.querySelector('.zoom-overlay')
      document.body.removeChild(overlay)
      document.body.style.overflow = 'auto'
    }
  }
}
