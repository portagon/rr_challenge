
module Platforms
  class Base
    class Step
      attr_reader :type, :title, :config

      def initialize(type, title, config = {})
        @type = type
        @title = title
        @config = config
      end

      def to_h
        { type: type, title: title, config: config }
      end
    end

    def self.title(val = nil)
      if val
        @title = val
      else
        @title || (superclass.respond_to?(:title) ? superclass.title : nil)
      end
    end

    def self.steps
      @steps ||= []
    end

    def self.step(type, title, config = {})
      steps << Step.new(type, title, config)
    end

    def self.inherited(subclass)
      subclass.instance_variable_set(:@steps, steps.dup)
      super
    end

    def call(index = 0)
      StepEnumerator.new(self.class.steps, index)
    end

    def workflow_title
      self.class.title
    end

    class StepEnumerator
      def initialize(steps, index)
        @steps = steps.dup
        @index = index
      end

      def next
        raise StopIteration if @index >= @steps.length
        step = @steps[@index]
        @index += 1
        step.to_h
      end

      def previous
        raise StopIteration if @index <= 0
        @index -= 1
        @steps[@index-1].to_h
      end

      def current
        return nil if @index < 0 || @index >= @steps.length
        @steps[@index].to_h
      end

      def last?
        @index >= (@steps.length - 1)
      end

      def reset
        @index = 0
      end
    end
  end
end
