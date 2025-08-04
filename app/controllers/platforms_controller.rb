class PlatformsController < ApplicationController
  include StepsHelper

  before_action :set_platform_and_enumerator, only: %i[steps submit_step]

  def index; end

  def steps
    render_step
  end

  def submit_step
    answers = wizard_answers["answers"]
    step_index = params[:step_index].to_i
    value = params[:step_value]
    error = validate_step(@enumerator.current, value)

    case params[:commit]
    when "Finish"
      wizard_answers[:finished] = true
      @finished = true
      return render_step
    when "Back"
      @enumerator.previous
      step_index = [step_index - 1, 0].max
      return render_step(step_index: step_index, value: answers[step_index.to_s])
    end

    if error
      return render_step(step_index: step_index, error: error, value: value)
    end

    answers[step_index.to_s] = value
    wizard_answers[:step_index] = step_index + 1
    @enumerator.next

    render_step(step_index: wizard_answers[:step_index], value: answers[wizard_answers[:step_index].to_s])
  end

  private

  def set_platform_and_enumerator
    @platform_class = params[:platform_class]
    step_index = params[:step_index]&.to_i || wizard_answers["step_index"] || 0
    platform = Object.const_get(@platform_class).new
    @enumerator = platform.call(step_index)
    @step = @enumerator.current
    @finished = wizard_answers["finished"]
    @step_index = step_index
    @error = nil
  end

  def render_step(step_index: nil, error: nil, value: nil)
    @step_index = step_index.presence || wizard_answers["step_index"]
    @step = @enumerator.current
    @step_value = value || wizard_answers.dig("answers", @step_index.to_s)
    @error = error
    @last_step = @enumerator.last?
    render partial: "steps/step"
  end

  def validate_step(step, value)
    case step[:type]
    when :amount_input
      min = step.dig(:config, :min) || 0
      max = step.dig(:config, :max) || Float::INFINITY
      val = value.to_i
      return "Please enter a valid value between #{min} and #{max}" unless val.between?(min, max)
    when :text_input
      presence_required = step.dig(:config, :presence)
      return "This field cannot be blank" if presence_required && value.to_s.strip.empty?
    when :checkbox
      required = step.dig(:config, :required)
      return "You must select to proceed" if required && value.nil?
    end
    nil
  end

  def wizard_answers
    session[:wizard] ||= {}
    session[:wizard][@platform_class] ||= { step_index: 0, answers: {}, finished: false }.with_indifferent_access
  end
end
