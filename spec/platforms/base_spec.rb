require 'rails_helper'

RSpec.describe Platforms::Base do
  let(:base_class) { described_class }

  describe '.title' do
    it 'can set and get the class title' do
      base_class.title("Base Workflow")
      expect(base_class.title).to eq("Base Workflow")
    end

    it 'inherits title from superclass if not set' do
      base_class.title("Base Title")
      subclass = Class.new(base_class)
      expect(subclass.title).to eq("Base Title")
    end

    it 'allows subclass to override title' do
      base_class.title("Base Title")
      subclass = Class.new(base_class)
      subclass.title("Sub Title")
      expect(subclass.title).to eq("Sub Title")
    end
  end

  describe '.step' do
    before do
      base_class.steps.clear
      base_class.step(:type1, "Title 1", foo: 'bar')
      base_class.step(:type2, "Title 2")
    end

    it 'adds steps to class steps array' do
      expect(base_class.steps.size).to eq(2)
      expect(base_class.steps.first.type).to eq(:type1)
      expect(base_class.steps.first.title).to eq("Title 1")
      expect(base_class.steps.first.config).to eq(foo: 'bar')
    end

    it 'inherits and duplicates steps on subclassing' do
      subclass = Class.new(base_class)
      expect(subclass.steps.size).to eq(2)
      expect(subclass.steps).not_to equal(base_class.steps) # different arrays
    end
  end

  describe '#call and StepEnumerator' do
    before do
      base_class.steps.clear
      base_class.step(:type1, "Step 1")
      base_class.step(:type2, "Step 2")
      @instance = base_class.new
    end

    let(:enumerator) { @instance.call }

    it 'starts at step index 0 by default' do
      expect(enumerator.current[:title]).to eq("Step 1")
    end

    it 'moves forward with next and returns step hash' do
      step1 = enumerator.next
      expect(step1[:title]).to eq("Step 1")
      step2 = enumerator.next
      expect(step2[:title]).to eq("Step 2")
    end

    it 'raises StopIteration after last step in next' do
      enumerator.next
      enumerator.next
      expect { enumerator.next }.to raise_error(StopIteration)
    end

    it 'moves backward with previous' do
      enumerator.next # move to first step
      enumerator.next # move to second step
      expect(enumerator.previous[:title]).to eq("Step 1")
    end

    it 'raises StopIteration when calling previous at beginning' do
      expect { enumerator.previous }.to raise_error(StopIteration)
    end

    it 'returns current step' do
      expect(enumerator.current[:title]).to eq("Step 1")
      enumerator.next
      expect(enumerator.current[:title]).to eq("Step 2")
    end

    it 'last? is true at last step' do
      expect(enumerator.last?).to be_falsey
      enumerator.next
      expect(enumerator.last?).to be_truthy
    end

    it 'reset sets the enumerator back to beginning' do
      enumerator.next
      enumerator.reset
      expect(enumerator.current[:title]).to eq("Step 1")
    end
  end

  describe '#workflow_title' do
    it 'returns the class title' do
      base_class.title("Workflow Main Title")
      instance = base_class.new
      expect(instance.workflow_title).to eq("Workflow Main Title")
    end
  end
end
