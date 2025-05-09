import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tutorial"
export default class extends Controller {
  static targets = [
    "progressBar", 
    "progressText", 
    "lightbox", 
    "lightboxImage", 
    "codeBlock",
    "quizForm",
    "quizResult",
    "quizScore",
    "feedbackForm",
    "copyLinkButton",
    "copyLinkInput",
    "copyLinkText"
  ]
  
  static values = {
    progress: Number,
    totalSteps: Number,
    currentStep: Number
  }

  connect() {
    // Initialize syntax highlighting for code blocks if Prism is available
    if (window.Prism) {
      this.codeBlockTargets.forEach(block => {
        Prism.highlightElement(block)
      })
    }
    
    // Set initial progress
    this.updateProgressBar()
  }

  // Progress tracking
  updateProgressBar() {
    if (this.hasProgressBarTarget && this.hasProgressTextTarget) {
      const percentComplete = this.progressValue || 0
      this.progressBarTarget.style.width = `${percentComplete}%`
      this.progressTextTarget.textContent = `${percentComplete}%`
    }
  }

  progressValueChanged() {
    this.updateProgressBar()
  }

  nextStep() {
    if (this.currentStepValue < this.totalStepsValue) {
      this.currentStepValue += 1
      
      // Calculate new progress percentage
      const newProgress = Math.round((this.currentStepValue / this.totalStepsValue) * 100)
      this.progressValue = newProgress
      
      // Scroll to next step
      const nextStepElement = document.getElementById(`step-${this.currentStepValue}`)
      if (nextStepElement) {
        window.scrollTo({
          top: nextStepElement.offsetTop - 100,
          behavior: 'smooth'
        })
      }
    }
  }

  previousStep() {
    if (this.currentStepValue > 1) {
      this.currentStepValue -= 1
      
      // Calculate new progress percentage
      const newProgress = Math.round((this.currentStepValue / this.totalStepsValue) * 100)
      this.progressValue = newProgress
      
      // Scroll to previous step
      const prevStepElement = document.getElementById(`step-${this.currentStepValue}`)
      if (prevStepElement) {
        window.scrollTo({
          top: prevStepElement.offsetTop - 100,
          behavior: 'smooth'
        })
      }
    }
  }

  // Image Lightbox
  openLightbox(event) {
    const image = event.currentTarget
    
    if (this.hasLightboxTarget && this.hasLightboxImageTarget) {
      // Set the lightbox image source to the clicked image
      this.lightboxImageTarget.src = image.src
      this.lightboxImageTarget.alt = image.alt
      
      // Show the lightbox
      this.lightboxTarget.classList.remove('hidden')
      document.body.classList.add('overflow-hidden')
    }
  }

  closeLightbox() {
    if (this.hasLightboxTarget) {
      this.lightboxTarget.classList.add('hidden')
      document.body.classList.remove('overflow-hidden')
    }
  }

  // Quiz functionality
  submitQuiz(event) {
    event.preventDefault()
    
    if (this.hasQuizFormTarget && this.hasQuizResultTarget && this.hasQuizScoreTarget) {
      const form = this.quizFormTarget
      const formData = new FormData(form)
      
      // Calculate score (this is simplified - in a real app you'd compare with correct answers)
      let correctAnswers = 0
      let totalQuestions = 0
      
      // For demo purposes, assume correct answers are stored in data attributes
      form.querySelectorAll('.quiz-question').forEach(question => {
        totalQuestions++
        const correctAnswer = question.dataset.correctAnswer
        const selectedAnswer = formData.get(`question-${question.dataset.questionId}`)
        
        if (selectedAnswer === correctAnswer) {
          correctAnswers++
          question.classList.add('correct-answer')
        } else {
          question.classList.add('incorrect-answer')
        }
      })
      
      // Calculate percentage
      const scorePercentage = Math.round((correctAnswers / totalQuestions) * 100)
      
      // Display the result
      this.quizScoreTarget.textContent = `${correctAnswers}/${totalQuestions} (${scorePercentage}%)`
      this.quizResultTarget.classList.remove('hidden')
      
      // Update progress if score is good
      if (scorePercentage >= 70) {
        // Increment progress by a fraction of the total for completing the quiz
        this.progressValue = Math.min(100, this.progressValue + 10)
      }
    }
  }

  resetQuiz() {
    if (this.hasQuizFormTarget && this.hasQuizResultTarget) {
      this.quizFormTarget.reset()
      this.quizResultTarget.classList.add('hidden')
      
      // Remove correct/incorrect styling
      this.quizFormTarget.querySelectorAll('.quiz-question').forEach(question => {
        question.classList.remove('correct-answer', 'incorrect-answer')
      })
    }
  }

  // Feedback form toggle
  toggleFeedbackForm(event) {
    if (this.hasFeedbackFormTarget) {
      const button = event.currentTarget
      const allButtons = document.querySelectorAll('.feedback-btn')
      
      // Toggle active state on the clicked button
      allButtons.forEach(btn => btn.classList.remove('active'))
      button.classList.add('active')
      
      // Show the feedback form
      this.feedbackFormTarget.classList.toggle('hidden')
    }
  }
  
  // Copy link functionality
  copyLink() {
    if (this.hasCopyLinkInputTarget && this.hasCopyLinkButtonTarget && this.hasCopyLinkTextTarget) {
      // Get the URL from the input
      const url = this.copyLinkInputTarget.value
      
      // Copy to clipboard
      navigator.clipboard.writeText(url).then(() => {
        // Update button text temporarily
        const originalText = this.copyLinkTextTarget.textContent
        this.copyLinkTextTarget.textContent = 'Copied!'
        
        // Reset button text after a delay
        setTimeout(() => {
          this.copyLinkTextTarget.textContent = originalText
        }, 2000)
      })
    }
  }
}
