import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="help-accordion"
export default class extends Controller {
  static targets = ["item", "content", "icon"]
  
  connect() {
    // Initialize with first item open if on mobile
    if (window.innerWidth < 768) {
      this.openItem(0)
    }
  }
  
  toggle(event) {
    const item = event.currentTarget
    const index = this.itemTargets.indexOf(item)
    
    // Toggle the clicked item
    if (this.isOpen(index)) {
      this.closeItem(index)
    } else {
      // Close all items first
      this.closeAll()
      // Then open the clicked item
      this.openItem(index)
    }
  }
  
  isOpen(index) {
    return !this.contentTargets[index].classList.contains('hidden')
  }
  
  openItem(index) {
    this.contentTargets[index].classList.remove('hidden')
    this.iconTargets[index].classList.add('transform', 'rotate-180')
  }
  
  closeItem(index) {
    this.contentTargets[index].classList.add('hidden')
    this.iconTargets[index].classList.remove('transform', 'rotate-180')
  }
  
  closeAll() {
    this.contentTargets.forEach((content, index) => {
      content.classList.add('hidden')
      this.iconTargets[index].classList.remove('transform', 'rotate-180')
    })
  }
}
