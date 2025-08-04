import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  change(event) {
    const platform = event.target.value;
    const container = document.getElementById('step_container');

    if (platform) {
      container.src = `/steps?platform_class=${encodeURIComponent(platform)}`;
    } else {
      container.innerHTML = "";
      container.removeAttribute("src");
    }
  }
}
