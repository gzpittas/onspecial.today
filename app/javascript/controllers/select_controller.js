// app/javascript/controllers/select_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.addEventListener('mouseup', this.preventMouseUp)
    this.element.addEventListener('focus', this.selectAll)
  }

  disconnect() {
    this.element.removeEventListener('mouseup', this.preventMouseUp)
    this.element.removeEventListener('focus', this.selectAll)
  }

  selectAll(event) {
    event.target.select()
  }

  preventMouseUp(event) {
    event.preventDefault()
  }
}