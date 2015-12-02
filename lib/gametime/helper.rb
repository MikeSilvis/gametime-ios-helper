require 'colorize'
Dir["#{File.dirname(__FILE__)}/helper/*.rb"].sort_by(&:length).reject { |file| file.match(/version/) }.each { |f| load(f) }

module Gametime
  module Helper
    def self.verify
      Gametime::Helper::VerifyTracking.new.verify
      Gametime::Helper::VerifyLocalization.new.verify
      Gametime::Helper::VerifyObservers.new.verify
    end
  end
end
