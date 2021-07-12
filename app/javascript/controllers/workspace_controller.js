import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['flash', 'persistedState'];

  updateForm(event) {
    const { flash, persistedState } = event.detail[0];
    this.persistedStateTarget.value = JSON.stringify(persistedState);
    this.flashTarget.innerHTML = flash;
  }
}
