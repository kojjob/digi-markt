import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "content"]
  
  connect() {
    // Check if there's a hash in the URL
    if (window.location.hash) {
      const tabId = window.location.hash.substring(1)
      const matchingTab = this.tabTargets.find(tab => tab.dataset.tab === tabId)
      
      if (matchingTab) {
        this.select({ currentTarget: matchingTab, preventDefault: () => {} })
        return
      }
    }
    
    // Default to first tab if no hash or no matching tab
    this.select({ currentTarget: this.tabTargets[0], preventDefault: () => {} })
  }
  
  select(event) {
    event.preventDefault()
    
    const selectedTab = event.currentTarget
    const tabId = selectedTab.dataset.tab
    
    // Update tabs
    this.tabTargets.forEach(tab => {
      if (tab.dataset.tab === tabId) {
        tab.setAttribute("aria-selected", "true")
        tab.classList.add("text-indigo-600", "border-b-2", "border-indigo-600")
        tab.classList.remove("text-gray-700", "border-transparent", "hover:text-gray-900", "hover:border-gray-300")
      } else {
        tab.setAttribute("aria-selected", "false")
        tab.classList.remove("text-indigo-600", "border-b-2", "border-indigo-600")
        tab.classList.add("text-gray-700", "border-transparent", "hover:text-gray-900", "hover:border-gray-300")
      }
    })
    
    // Update content
    this.contentTargets.forEach(content => {
      if (content.dataset.tabContent === tabId) {
        content.classList.remove("hidden")
        content.classList.add("block")
      } else {
        content.classList.add("hidden")
        content.classList.remove("block")
      }
    })
    
    // Update URL hash without scrolling
    const scrollPosition = window.pageYOffset
    window.location.hash = tabId
    window.scrollTo(window.scrollX, scrollPosition)
  }
}