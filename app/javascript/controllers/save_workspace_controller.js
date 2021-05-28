import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['field'];

  markSaveInProgress() {
    this.fieldTarget.value = true;
  }
}
