import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["loader", "form"]

  connect() {
    this.element.addEventListener("input", this.validateInline.bind(this))
    this.element.addEventListener("turbo:submit-start", this.showLoader.bind(this))
    this.element.addEventListener("turbo:frame-render", this.hideLoader.bind(this))
  }

  showLoader() {
    if (this.hasLoaderTarget) {
      this.loaderTarget.classList.remove('d-none')
    }
  }

  hideLoader() {
    if (this.hasLoaderTarget) {
      this.loaderTarget.classList.add('d-none')
    }
  }

  validateInline(event) {
    const input = event.target
    if (input.name === "step_value") {
      if (input.type === "text" && input.dataset.presence === "true" && input.value.trim() === "") {
        input.setCustomValidity("This field cannot be blank")
      } else if (!isNaN(parseInt(input.min)) && input.value && parseInt(input.value) < parseInt(input.min)) {
        input.setCustomValidity(`Must be at least ${input.min}`)
      } else if (!isNaN(parseInt(input.max)) && input.value && parseInt(input.value) > parseInt(input.max)) {
        input.setCustomValidity(`Must be at most ${input.max}`)
      } else {
        input.setCustomValidity("")
      }
      input.reportValidity()
    }
  }

  submitBack(event) {
    event.preventDefault()
    this.formTarget.action = "/platforms/back_step"
    this.formTarget.requestSubmit()
  }

  submitFinish(event) {
    event.preventDefault()
    this.formTarget.action = "/platforms/finish"
    this.formTarget.requestSubmit()
  }
}
