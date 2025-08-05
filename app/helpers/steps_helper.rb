module StepsHelper
  def render_step(step, value: nil, error: nil)
    content_tag(:div, class: "mb-2") do
      concat(content_tag(:h5, step[:title], class: "mb-3 fw-semibold"))
      concat(render_step_input(step, value))
      concat(content_tag(:div, error, class: "alert alert-danger mt-3 mb-0")) if error
    end
  end

  def render_step_input(step, value)
    case step[:type]
    when :amount_input
      text_field_tag(:step_value, value, min: step.dig(:config, :min), max: step.dig(:config, :max),
                      class: "form-control form-control-lg mb-2 shadow-sm", placeholder: "Enter an amount", autofocus: true, required: true)
    when :text_input
      text_field_tag(:step_value, value, placeholder: step.dig(:config, :placeholder),
                     class: "form-control form-control-lg mb-2 shadow-sm", required: step.dig(:config, :presence), autofocus: true,
                     data: { presence: step.dig(:config, :presence) })
    when :checkbox
      content_tag(:div, class: "form-check mb-2") do
        check_box_tag(:step_value, "1", value == "1", class: "form-check-input", required: step.dig(:config, :required)) +
        label_tag(:step_value, step.dig(:config, :label), class: "form-check-label ms-2")
      end
    when :disclaimer
      content_tag(:div, step.dig(:config, :text), class: "alert alert-warning mt-2")
    else
      content_tag(:div, "Unknown step type", class: "text-muted")
    end
  end
end
