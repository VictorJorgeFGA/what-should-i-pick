import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }

// Create the observer, same as before:
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
