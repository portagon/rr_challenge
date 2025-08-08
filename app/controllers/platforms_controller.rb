class PlatformsController < ApplicationController
  include StepsHelper

  before_action :set_platform_and_enumerator, only: %i[steps next_step back_step finish]

  def index; end

  def steps
    respond_to do |format|
      format.html { render_step }
      format.turbo_stream { render_step(is_turbo_stream: true) }
    end
  end

  def next_step
    process_step(params[:step_index].to_i, params[:step_value]) do
      wizard_answers["step_index"] = params[:step_index].to_i + 1
      @enumerator.next
    end
  end

  def back_step
    step_index = [ params[:step_index].to_i - 1, 0 ].max
    @enumerator.previous
    respond_to do |format|
      format.html { render_step(step_index: step_index, value: wizard_answers["answers"][step_index.to_s]) }
      format.turbo_stream { render_step(step_index: step_index, value: wizard_answers["answers"][step_index.to_s], is_turbo_stream: true) }
    end
  end

  def finish
    wizard_answers[:finished] = true
    @finished = true
    respond_to do |format|
      format.html { render_step }
      format.turbo_stream { render_step(is_turbo_stream: true) }
    end
  end

  private

  def process_step(step_index, value)
    answers = wizard_answers["answers"]
    error = validate_step(@enumerator.current, value)

    if error
      respond_to do |format|
        format.html { render_step(step_index: step_index, error: error, value: value) }
        format.turbo_stream { render_step(step_index: step_index, error: error, value: value, is_turbo_stream: true) }
      end
      return
    end

    answers[step_index.to_s] = value
    yield if block_given?

    respond_to do |format|
      format.html { render_step(step_index: wizard_answers["step_index"], value: answers[wizard_answers["step_index"].to_s]) }
      format.turbo_stream { render_step(step_index: wizard_answers["step_index"], value: answers[wizard_answers["step_index"].to_s], is_turbo_stream: true) }
    end
  end

  def render_step(step_index: nil, error: nil, value: nil, is_turbo_stream: false)
    @step_index = step_index.presence || wizard_answers["step_index"]
    @step = @enumerator.current
    @step_value = value || wizard_answers.dig("answers", @step_index.to_s)
    @error = error
    @last_step = @enumerator.last?
    @total_steps = @enumerator.total_steps

    if is_turbo_stream
      render turbo_stream: turbo_stream.replace("step_container", partial: "steps/step")
    else
      render partial: "steps/step"
    end
  end

  def set_platform_and_enumerator
    @platform_class = params[:platform_class]

    klass = PLATFORM_CLASS_AND_NAME_MAP.fetch(@platform_class) do
      raise ArgumentError, "Unknown platform class: #{@platform_class}"
    end
    step_index = params[:step_index]&.to_i || wizard_answers["step_index"] || 0
    platform = klass.new
    @enumerator = platform.call(step_index)
    @step = @enumerator.current
    @finished = wizard_answers["finished"]
    @step_index = step_index
    @error = nil
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
