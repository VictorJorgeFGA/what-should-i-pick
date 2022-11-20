import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  change(event) {
    event.preventDefault();
    let pressed_button_href = event.currentTarget.getAttribute('href');
    console.log(pressed_button_href);

    let xhr = new XMLHttpRequest();
    xhr.open("POST", pressed_button_href, true);
    xhr.setRequestHeader('X-CSRF-Token', document.querySelector('meta[name="csrf-token"]').getAttribute('content'))
    xhr.onreadystatechange = function () {
      Turbo.visit(document.location.pathname);
    }
    xhr.send();
  }
}
