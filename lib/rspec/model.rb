# frozen_string_literal: true

require_relative "model/version"
require_relative "specs"

module RSpec
  module Model # :nodoc:
    def self.included(base)
      base.extend RSpec::Specs
    end
  end
end
