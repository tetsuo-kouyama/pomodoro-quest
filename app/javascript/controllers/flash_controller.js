import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flash"
export default class extends Controller {
  connect() {
    document.querySelectorAll("[data-controller='flash']").forEach((element) => {
      if (element !== this.element) {
        element.remove()
      }
    })

    setTimeout(() => {
      this.element.remove()
    }, 3000)
  }
}
