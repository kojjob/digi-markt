import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="validation"
export default class extends Controller {
  static targets = [
    "nameInput", "nameError", 
    "emailInput", "emailError", 
    "phoneInput", "phoneError", 
    "subjectInput", "subjectError", 
    "messageInput", "messageError", 
    "privacyInput", "privacyError"
  ];
  
  validateName() {
    const input = this.nameInputTarget;
    const error = this.nameErrorTarget;
    
    if (!input.value.trim()) {
      error.classList.remove('hidden');
      input.classList.add('border-red-500');
      return false;
    } else {
      error.classList.add('hidden');
      input.classList.remove('border-red-500');
      return true;
    }
  }
  
  validateEmail() {
    const input = this.emailInputTarget;
    const error = this.emailErrorTarget;
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    
    if (!emailRegex.test(input.value.trim())) {
      error.classList.remove('hidden');
      input.classList.add('border-red-500');
      return false;
    } else {
      error.classList.add('hidden');
      input.classList.remove('border-red-500');
      return true;
    }
  }
  
  validatePhone() {
    const input = this.phoneInputTarget;
    const error = this.phoneErrorTarget;
    
    if (input.value.trim() === '') {
      error.classList.add('hidden');
      input.classList.remove('border-red-500');
      return true;
    }
    
    const phoneRegex = /^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$/;
    
    if (!phoneRegex.test(input.value.trim())) {
      error.classList.remove('hidden');
      input.classList.add('border-red-500');
      return false;
    } else {
      error.classList.add('hidden');
      input.classList.remove('border-red-500');
      return true;
    }
  }
  
  validateSubject() {
    const input = this.subjectInputTarget;
    const error = this.subjectErrorTarget;
    
    if (!input.value) {
      error.classList.remove('hidden');
      input.classList.add('border-red-500');
      return false;
    } else {
      error.classList.add('hidden');
      input.classList.remove('border-red-500');
      return true;
    }
  }
  
  validateMessage() {
    const input = this.messageInputTarget;
    const error = this.messageErrorTarget;
    
    if (!input.value.trim()) {
      error.classList.remove('hidden');
      input.classList.add('border-red-500');
      return false;
    } else {
      error.classList.add('hidden');
      input.classList.remove('border-red-500');
      return true;
    }
  }
  
  validatePrivacy() {
    const input = this.privacyInputTarget;
    const error = this.privacyErrorTarget;
    
    if (!input.checked) {
      error.classList.remove('hidden');
      return false;
    } else {
      error.classList.add('hidden');
      return true;
    }
  }
  
  validateForm(event) {
    const isNameValid = this.validateName();
    const isEmailValid = this.validateEmail();
    const isPhoneValid = this.validatePhone();
    const isSubjectValid = this.validateSubject();
    const isMessageValid = this.validateMessage();
    const isPrivacyValid = this.validatePrivacy();
    
    if (!(isNameValid && isEmailValid && isPhoneValid && isSubjectValid && isMessageValid && isPrivacyValid)) {
      event.preventDefault();
    }
  }
}
