// app/javascript/controllers/select_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  connect() {
    this.inputTargets.forEach(input => {
      input.addEventListener('click', this.selectAll.bind(this))
      input.addEventListener('focus', this.selectAll.bind(this))
    })
  }

  selectAll(event) {
    event.target.select()
  }

  disconnect() {
    this.inputTargets.forEach(input => {
      input.removeEventListener('click', this.selectAll)
      input.removeEventListener('focus', this.selectAll)
    })
  }
}