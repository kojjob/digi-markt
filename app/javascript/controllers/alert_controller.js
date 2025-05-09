import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="alert"
export default class extends Controller {
  close() {
    this.element.classList.add('opacity-0', 'transition-opacity', 'duration-300')
    setTimeout(() => {
      this.element.remove()
    }, 300)
  }
}
