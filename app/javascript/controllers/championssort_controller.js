import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  update_sort(event) {
    const event_element = event.currentTarget;
    const field_to_sort = event_element.getAttribute('value');
    const sort_triggered = event_element.getAttribute('data-sort-triggered');
    let sort_type = event_element.getAttribute('data-sort-value');

    sort_type = sort_type == 'desc' ? 'asc' : 'desc';
    let form_input_target = document.getElementById('form-sort');
    form_input_target.value = `${field_to_sort}-${sort_type}`;

    document.getElementById('filter-form').submit();
  }
}
