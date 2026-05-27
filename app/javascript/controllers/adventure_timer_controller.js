import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="adventure-timer"
export default class extends Controller {
  static targets = ["time"]
  static values = {
    endTime: Number
  }

  connect() {
    this.tick()

    this.timer = setInterval(() => {
      this.tick()
    }, 1000);
  }

  disconnect() {
    clearInterval(this.timer)
  }

  tick() {
    const now = Date.now()

    const remainingSeconds = Math.floor(
      (this.endTimeValue - now) / 1000
    )

    if (remainingSeconds <= 0) {
      this.timeTarget.textContent = "00:00"

      clearInterval(this.timer)

      Turbo.visit(window.location.href)

      return
    }

    this.timeTarget.textContent = this.formatTime(remainingSeconds)
  }

  formatTime(totalSeconds) {
    const minutes = Math.floor(totalSeconds / 60)
    const seconds = totalSeconds % 60

    const m = String(minutes).padStart(2, "0")
    const s = String(seconds).padStart(2, "0")

    return `${m}:${s}`
  }
}
