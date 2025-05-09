import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="accordion"
export default class extends Controller {
  static targets = ["button", "content", "icon", "trigger"];

  connect() {
    // Check if any accordion items should be open by default
    this.element.querySelectorAll('[data-accordion-target="trigger"][aria-expanded="true"]').forEach(trigger => {
      const content = trigger.nextElementSibling
      const icon = trigger.querySelector('[data-accordion-target="icon"]')
      
      if (content && icon) {
        content.classList.remove("hidden")
        icon.classList.add("rotate-180")
      }
    })
  }
  
  toggle(event) {
    const trigger = event.currentTarget
    const content = trigger.nextElementSibling
    const icon = trigger.querySelector('[data-accordion-target="icon"]')
    
    const isExpanded = trigger.getAttribute("aria-expanded") === "true"
    
    if (isExpanded) {
      content.classList.add("hidden")
      icon.classList.remove("rotate-180")
      trigger.setAttribute("aria-expanded", "false")
    } else {
      content.classList.remove("hidden")
      icon.classList.add("rotate-180")
      trigger.setAttribute("aria-expanded", "true")
    }
  }
}
