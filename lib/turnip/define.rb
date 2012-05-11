module Turnip
  module Define
    def step(expression, &block)
      step = Turnip::StepDefinition.new(expression, &block)
      send(:define_method, "match: #{expression}") { |description| step.match(description) }
      if expression.is_a? Regexp
        send(:define_method, "execute: #{expression}", &block)
      else
        send(:define_method, expression, &block)
      end
    end
  end
end
