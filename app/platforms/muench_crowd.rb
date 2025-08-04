module Platforms
  class MuenchCrowd < Base
    title "MuenchCrowd"
    step :amount_input, "How much would you like to invest?", { min: 250, max: 10000 }
    step :checkbox, "Do you accept the terms?", { label: "I agree to the terms and conditions." }
    step :disclaimer, "Please confirm", { text: "This is a speculative investment. Capital is at risk." }
  end
end
