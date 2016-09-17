module Gametime
  module Helper
    class VerifyObservers
      def verify
        puts 'Verifying all observers are deinit on the view'.colorize(:blue)

        valid_event = true
        files_with_observers = `grep 'addObserver' -R Classes/ Tonight/ -l`.split("\n")
        files_with_observers.each do |file|
          search_results = `grep removeObserver "#{file}"`

          if search_results == ""
            valid_event = false
            puts "missing remove #{file}".colorize(:red)
          end
        end

        valid_event ? (puts 'All Good'.colorize(:green)) : (puts 'Errors Occured'.colorize(:red))
      end
    end
  end
end
