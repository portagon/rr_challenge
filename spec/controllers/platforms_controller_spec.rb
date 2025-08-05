require 'rails_helper'

class TestPlatform < Platforms::Base
  title "Test Platform"

  step :amount_input, "Enter Amount", min: 1, max: 10
  step :text_input, "Enter Text", presence: true
  step :checkbox, "Check Me", required: true
end

RSpec.describe PlatformsController, type: :controller do
  render_views

  let(:platform_class) { "TestPlatform" }
  let(:step_index) { 0 }
  let(:wizard_session) do
    {
      platform_class => {
        'step_index' => step_index,
        'answers' => {},
        'finished' => false
      }
    }
  end

  let(:enumerator) { double("StepEnumerator") }
  let(:test_platform) { instance_double("TestPlatform") }
  let(:current_step) { { type: :amount_input, config: { min: 1, max: 10 } } }

  before do
    stub_const("TestPlatform", Class.new)

    allow(TestPlatform).to receive(:new).and_return(test_platform)

    allow(test_platform).to receive(:call).and_return(enumerator)

    allow(enumerator).to receive(:current).and_return(current_step)
    allow(enumerator).to receive(:last?).and_return(false)
    allow(enumerator).to receive(:next)
    allow(enumerator).to receive(:previous)
    allow(enumerator).to receive(:total_steps)
    session[:wizard] = wizard_session
  end

  describe "GET #steps" do
    it "renders the step partial" do
      get :steps, params: { platform_class: platform_class }
      expect(response).to render_template(partial: "steps/_step")
      expect(assigns(:step)).to eq(current_step)
    end
  end

  describe "POST #submit_step" do
    context "when committing 'Finish'" do
      it "marks the wizard as finished and renders the step" do
        post :submit_step,
          params: {
            platform_class: platform_class,
            commit: "Finish",
            step_index: step_index,
            step_value: "5"
          }

        expect(session[:wizard][platform_class][:finished]).to be true
        expect(response).to render_template(partial: "steps/_step")
      end
    end

    context "when committing 'Back'" do
      it "goes back to the previous step and renders the step" do
        post :submit_step,
          params: {
            platform_class: platform_class,
            commit: "Back",
            step_index: step_index,
            step_value: "5"
          }

        expect(enumerator).to have_received(:previous)
        expect(response).to render_template(partial: "steps/_step")
      end
    end

    context "when there is a validation error" do
      it "renders the step with an error message" do
        post :submit_step,
          params: {
            platform_class: platform_class,
            step_index: step_index,
            step_value: "20" # Invalid value (out of range)
          }

        expect(response).to render_template(partial: "steps/_step")
        expect(assigns(:error)).to eq("Please enter a valid value between 1 and 10")
      end
    end

    context "when the step is valid" do
      it "saves the answer and moves to the next step" do
        post :submit_step,
          params: {
            platform_class: platform_class,
            step_index: step_index,
            step_value: "5"
          }

        expect(session[:wizard][platform_class]['answers'][step_index.to_s]).to eq("5")
        expect(enumerator).to have_received(:next)
        expect(response).to render_template(partial: "steps/_step")
      end
    end
  end
end
