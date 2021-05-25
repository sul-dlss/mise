import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['container', 'title'];

  copyFormTemplate(event) {
    const modalFormTemplate = event.target.nextElementSibling;
    this.containerTarget.innerHTML = modalFormTemplate.innerHTML;
    this.titleTarget.innerText = modalFormTemplate.dataset.title;
  }
}
