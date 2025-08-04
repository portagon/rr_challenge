import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  change(event) {
    const platform = event.target.value;
    if (platform) {
      document.getElementById('step_container').src = `/steps?platform_class=${encodeURIComponent(platform)}`;
    }
  }
}
