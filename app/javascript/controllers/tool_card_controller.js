import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  open(event) {
    event.preventDefault()
    
    // In a real application, this would open a modal or redirect to the tool
    const toolName = this.element.querySelector('h3').textContent
    
    // Simple modal alert for demo purposes
    alert(`${toolName} would open in a modal in the real application.`)
  }
}
