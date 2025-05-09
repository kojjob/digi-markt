import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="help-toc"
export default class extends Controller {
  static targets = ["container", "content"]
  
  connect() {
    this.generateTableOfContents()
    this.setupScrollSpy()
  }
  
  generateTableOfContents() {
    const headings = this.contentTarget.querySelectorAll('h2, h3')
    if (headings.length === 0) return
    
    const toc = document.createElement('ul')
    toc.className = 'space-y-2'
    
    headings.forEach((heading, index) => {
      // Add ID to heading if it doesn't have one
      if (!heading.id) {
        heading.id = `heading-${index}`
      }
      
      const listItem = document.createElement('li')
      const link = document.createElement('a')
      link.href = `#${heading.id}`
      link.textContent = heading.textContent
      link.className = heading.tagName === 'H2' 
        ? 'block text-theme-secondary hover:text-indigo-600 transition-colors py-1'
        : 'block text-theme-secondary hover:text-indigo-600 transition-colors py-1 pl-4 text-sm'
      link.dataset.tocLink = heading.id
      
      listItem.appendChild(link)
      toc.appendChild(listItem)
    })
    
    this.containerTarget.appendChild(toc)
  }
  
  setupScrollSpy() {
    const tocLinks = this.element.querySelectorAll('[data-toc-link]')
    if (tocLinks.length === 0) return
    
    const headingElements = Array.from(this.contentTarget.querySelectorAll('h2, h3'))
    
    const setActiveLink = () => {
      const scrollPosition = window.scrollY + 100
      
      // Find the heading that is currently in view
      let currentHeading = null
      for (let i = 0; i < headingElements.length; i++) {
        const heading = headingElements[i]
        if (heading.offsetTop <= scrollPosition) {
          currentHeading = heading
        } else {
          break
        }
      }
      
      // Update active state in TOC
      if (currentHeading) {
        tocLinks.forEach(link => {
          if (link.dataset.tocLink === currentHeading.id) {
            link.classList.add('text-indigo-600', 'font-medium')
          } else {
            link.classList.remove('text-indigo-600', 'font-medium')
          }
        })
      }
    }
    
    // Initial check
    setActiveLink()
    
    // Listen for scroll events
    window.addEventListener('scroll', setActiveLink)
  }
}
