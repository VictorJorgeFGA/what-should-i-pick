import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['position'];

  selectPosition(event) {
    const selected_element = event.currentTarget;
    this.positionTargets.forEach((element, index) => {
      if (element !== selected_element) {
        element.children[0].style.setProperty('filter', 'grayscale(100%)');
      } else {
        element.children[0].style.setProperty('filter', 'grayscale(0%)');
      }
    });

    document.getElementById('form-position').value = selected_element.getAttribute('value');
  }
}
