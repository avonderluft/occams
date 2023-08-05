# frozen_string_literal: true

module Occams

  class Error < StandardError
  end

  class MissingSite < Occams::Error

    def initialize(identifier)
      super "Cannot find CMS Site with identifier: #{identifier}"
    end

  end

  class MissingLayout < Occams::Error

    def initialize(identifier)
      super "Cannot find CMS Layout with identifier: #{identifier}"
    end

  end

  class MissingPage < Occams::Error

    def initialize(path)
      super "Cannot find CMS Page at #{path}"
    end

  end

end
