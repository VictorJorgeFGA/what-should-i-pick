import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['position', 'tier'];

  initialize() {
    const observer = new IntersectionObserver(entries => {
        entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.classList.add('typewriter');
            return;
        }

            entry.target.classList.remove('typewriter');
        });
    });
    var texts = document.getElementsByClassName('typewriter');
    for (let item of texts) {
      observer.observe(item);
    }
  }

  updateVisualGrayscaleSelection = function (selected_element, elements) {
    elements.forEach((element, index) => {
      if (element !== selected_element) {
        element.classList.add('hoverable-grayscaled');
      } else {
        element.classList.remove('hoverable-grayscaled');
      }
    });
  }

  selectPosition(event) {
    const selected_element = event.currentTarget;
    this.updateVisualGrayscaleSelection(selected_element, this.positionTargets);
    document.getElementById('form-position').value = selected_element.getAttribute('value');
  }

  selectTier(event) {
    const selected_element = event.currentTarget;
    this.updateVisualGrayscaleSelection(selected_element, this.tierTargets);
    document.getElementById('form-tier').value = selected_element.getAttribute('value');
  }
}
