module Platforms
  class Clark < Base
    title "Clark"

    step :amount_input, "How much would you like to invest?", { min: 50, presence: true }
    step :text_input, "What is your motive?", { placeholder: "Enter your motive", presence: false }
    step :text_input, "Annual income?", { placeholder: "Enter your income", presence: false }
    step :text_input, "Profession?", { placeholder: "Enter your profession", presence: false }
    step :text_input, "Age?", { placeholder: "Enter your age", presence: false }
    step :text_input, "Address?", { placeholder: "Enter your Address", presence: false }
    step :checkbox, "Do you accept the terms?", { label: "I agree to the terms and conditions.", required: true }
    step :disclaimer, "Please confirm", { text: "This is a speculative investment. Capital is at risk." }
  end
end
