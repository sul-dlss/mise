import { Controller } from 'stimulus'

export default class extends Controller {
  copyFormTemplate(event) {
    const formTemplate = event.target.nextElementSibling
    const containerDiv = document.getElementById(formTemplate.dataset.container)
    containerDiv.innerHTML = formTemplate.innerHTML
  }
}
