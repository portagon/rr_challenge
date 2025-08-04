module Platforms
  class Portagon < Base
    title "Portagon"

    step :amount_input, "How much would you like to invest?", { min: 250, max: 10000 }
    step :text_input, "Why do you invest?", { placeholder: "Enter the reason", presence: true }
    step :checkbox, "Do you accept the terms?", { label: "I agree to the terms and conditions." }
    step :disclaimer, "Please confirm", { text: "This is a speculative investment. Capital is at risk." }
  end
end
