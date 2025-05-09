import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["results"]
  
  connect() {
    // Initialize empty search results
    this.resultsTarget.innerHTML = ""
    this.resultsTarget.classList.add("hidden")
    
    // Close search results when clicking outside
    document.addEventListener('click', event => {
      if (!this.element.contains(event.target) && !this.resultsTarget.contains(event.target)) {
        this.resultsTarget.classList.add("hidden")
      }
    })
  }
  
  search() {
    const query = this.element.value.trim().toLowerCase()
    
    if (query.length < 2) {
      this.resultsTarget.classList.add("hidden")
      return
    }
    
    // In a real application, this would fetch results from the server
    // This is just a mock implementation for demonstration
    this.fetchSearchResults(query)
      .then(results => this.displayResults(results, query))
  }
  
  fetchSearchResults(query) {
    // Mock search results - in a real app, this would be an API call
    const mockResults = [
      { title: "Getting Started with E-sika", category: "Getting Started", url: "#getting-started" },
      { title: "Setting Up Your Store", category: "Getting Started", url: "#getting-started" },
      { title: "Customizing Your Storefront", category: "Getting Started", url: "#getting-started" },
      { title: "Adding Your First Product", category: "Product Management", url: "#products" },
      { title: "Managing Physical Products", category: "Product Management", url: "#products" },
      { title: "Digital Products Setup", category: "Product Management", url: "#products" },
      { title: "Product Variants", category: "Product Management", url: "#products" },
      { title: "Inventory Management", category: "Product Management", url: "#products" },
      { title: "Setting Up Bookable Services", category: "Services", url: "#services" },
      { title: "Managing Staff Availability", category: "Services", url: "#services" },
      { title: "Configuring Dropshipping", category: "Advanced Features", url: "#advanced" },
      { title: "Setting Up Affiliate Marketing", category: "Advanced Features", url: "#advanced" }
    ]
    
    // Filter results based on query
    const filteredResults = mockResults.filter(result => 
      result.title.toLowerCase().includes(query) || 
      result.category.toLowerCase().includes(query)
    )
    
    // Simulate API delay
    return new Promise(resolve => {
      setTimeout(() => resolve(filteredResults), 200)
    })
  }
  
  displayResults(results, query) {
    this.resultsTarget.innerHTML = ""
    
    if (results.length === 0) {
      const noResults = document.createElement('div')
      noResults.className = 'p-6 text-center text-gray-500'
      noResults.textContent = `No results found for "${query}"`
      this.resultsTarget.appendChild(noResults)
    } else {
      results.forEach(result => {
        const resultItem = document.createElement('a')
        resultItem.href = result.url
        resultItem.className = 'block p-4 hover:bg-gray-50 border-b border-gray-100 last:border-0'
        
        // Highlight the matching text
        const title = this.highlightMatch(result.title, query)
        
        resultItem.innerHTML = `
          <div class="font-medium text-gray-900">${title}</div>
          <div class="text-sm text-gray-500">${result.category}</div>
        `
        
        resultItem.addEventListener('click', () => {
          this.element.value = ""
          this.resultsTarget.classList.add("hidden")
        })
        
        this.resultsTarget.appendChild(resultItem)
      })
    }
    
    this.resultsTarget.classList.remove("hidden")
  }
  
  highlightMatch(text, query) {
    // Simple function to highlight the matched text
    const regex = new RegExp(`(${query})`, 'gi')
    return text.replace(regex, '<mark class="bg-yellow-200 px-0.5 rounded">$1</mark>')
  }
}