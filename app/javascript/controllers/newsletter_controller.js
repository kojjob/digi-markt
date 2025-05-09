import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["email", "message"]
  
  connect() {
    // Set up form submission handler
    this.element.addEventListener('submit', this.handleSubmit.bind(this))
  }
  
  handleSubmit(event) {
    event.preventDefault()
    
    const emailInput = this.element.querySelector('input[type="email"]')
    if (!emailInput) return
    
    const email = emailInput.value.trim()
    
    if (email) {
      // In a real app, this would send the email to a server
      // For demo purposes, we'll just clear the input and show a message
      emailInput.value = ''
      
      // Show a success message
      alert(`Thank you for subscribing with ${email}! You would receive a confirmation email in a real application.`)
    }
  }
}