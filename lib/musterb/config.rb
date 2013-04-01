module Musterb
  module Config
    attr_accessor :partial_method

    def configure
      yield self
    end

    def partial_method
      @partial_method ||= :partial
    end

  end
end
