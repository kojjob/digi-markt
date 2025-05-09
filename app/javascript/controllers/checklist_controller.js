import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.addEventListener('change', this.updateProgress.bind(this))
    this.updateProgress()
  }
  
  updateProgress() {
    // Find all checkboxes in the same container
    const container = this.element.closest('.space-y-3').parentElement
    if (!container) return
    
    const checkboxes = container.querySelectorAll('input[type="checkbox"]')
    const totalChecks = checkboxes.length
    const checkedCount = [...checkboxes].filter(checkbox => checkbox.checked).length
    
    // Find progress bar and text
    const progressBar = container.querySelector('.bg-indigo-600')
    const progressText = container.querySelector('.text-xs.text-gray-600')
    
    if (progressBar && progressText) {
      const percentage = (checkedCount / totalChecks) * 100
      progressBar.style.width = `${percentage}%`
      progressText.textContent = `${checkedCount}/${totalChecks} tasks completed`
    }
  }
}

