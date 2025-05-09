import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="help-search"
export default class extends Controller {
  static targets = ["input", "results", "noResults", "categories", "popular"]
  
  connect() {
    // Initialize search functionality
    this.resultsTarget.classList.add('hidden')
    this.noResultsTarget.classList.add('hidden')
  }
  
  search() {
    const query = this.inputTarget.value.toLowerCase().trim()
    
    if (query.length < 2) {
      this.showDefaultContent()
      return
    }
    
    // Get all searchable elements
    const searchableElements = document.querySelectorAll('[data-searchable]')
    let hasResults = false
    
    // Clear previous results
    this.resultsTarget.innerHTML = ''
    
    // Search through elements
    searchableElements.forEach(element => {
      const title = element.getAttribute('data-title').toLowerCase()
      const category = element.getAttribute('data-category').toLowerCase()
      const content = element.getAttribute('data-content').toLowerCase()
      const excerpt = element.getAttribute('data-excerpt')?.toLowerCase() || ''
      const url = element.getAttribute('data-url')
      const categorySlug = element.getAttribute('data-category-slug')
      
      if (title.includes(query) || category.includes(query) || content.includes(query) || excerpt.includes(query)) {
        hasResults = true
        
        // Create result item
        const resultItem = document.createElement('div')
        resultItem.className = 'p-4 border-b border-theme-tertiary last:border-b-0'
        resultItem.innerHTML = `
          <a href="${url}" class="block hover:bg-theme-secondary rounded-lg p-3 transition-colors">
            <div class="text-xs text-theme-tertiary mb-1">${category}</div>
            <h3 class="text-theme-primary font-medium mb-1">${this.highlightMatch(title, query)}</h3>
            <p class="text-theme-secondary text-sm">${this.highlightMatch(excerpt, query)}</p>
          </a>
        `
        
        this.resultsTarget.appendChild(resultItem)
      }
    })
    
    // Show/hide appropriate content
    if (hasResults) {
      this.resultsTarget.classList.remove('hidden')
      this.noResultsTarget.classList.add('hidden')
      this.categoriesTarget.classList.add('hidden')
      this.popularTarget.classList.add('hidden')
    } else {
      this.resultsTarget.classList.add('hidden')
      this.noResultsTarget.classList.remove('hidden')
      this.categoriesTarget.classList.add('hidden')
      this.popularTarget.classList.add('hidden')
    }
  }
  
  reset() {
    this.inputTarget.value = ''
    this.showDefaultContent()
  }
  
  showDefaultContent() {
    this.resultsTarget.classList.add('hidden')
    this.noResultsTarget.classList.add('hidden')
    this.categoriesTarget.classList.remove('hidden')
    this.popularTarget.classList.remove('hidden')
  }
  
  highlightMatch(text, query) {
    if (!text) return ''
    
    // Escape special characters in the query
    const escapedQuery = query.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')
    
    // Create a regular expression to match the query (case-insensitive)
    const regex = new RegExp(`(${escapedQuery})`, 'gi')
    
    // Replace matches with highlighted version
    return text.replace(regex, '<span class="bg-yellow-200 dark:bg-yellow-800">$1</span>')
  }
}
