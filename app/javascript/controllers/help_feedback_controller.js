import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="help-feedback"
export default class extends Controller {
  static targets = ["thankYou", "feedbackForm", "feedbackText"]
  
  helpful() {
    this.thankYouTarget.classList.remove('hidden')
    this.feedbackFormTarget.classList.add('hidden')
    
    // Here you would typically send the feedback to the server
    console.log('Article was helpful')
  }
  
  notHelpful() {
    this.thankYouTarget.classList.add('hidden')
    this.feedbackFormTarget.classList.remove('hidden')
    
    // Here you would typically send the feedback to the server
    console.log('Article was not helpful')
  }
  
  submitFeedback() {
    const feedback = this.feedbackTextTarget.value
    
    // Here you would typically send the feedback to the server
    console.log('Feedback submitted:', feedback)
    
    this.feedbackFormTarget.classList.add('hidden')
    this.thankYouTarget.classList.remove('hidden')
  }
}
