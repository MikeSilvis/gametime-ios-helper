module Gametime
  module Helper
    class VerifyTracking
      def verify
        puts "Verifying all tracking events used".colorize(:blue)
        verify_no_missing_tracking_events ? (puts 'All Good'.colorize(:green)) : (puts 'Errors Occured'.colorize(:red))

        puts "Verifying all constants used in tracking events".colorize(:blue)
        verify_tracking_functions ? (puts 'All Good'.colorize(:green)) : (puts 'Errors Occured'.colorize(:red))
      end

      def verify_no_missing_tracking_events
        valid_event = true

        File.open('./Classes/GAMTrackingEvents.h').each do |line|
          if line.start_with?('static')
            tracking_event_name = line.match(/kTracking(\w*)/)
            search_results = `grep "#{tracking_event_name}" -R Classes/ | grep -v "GAMTrackingEvents.h"`

            if search_results.to_s == ""
              valid_event = false
              puts "Missing Event: #{tracking_event_name}".colorize(:red)
            end
          end
        end

        return valid_event
      end

      def verify_tracking_functions
        find_invalid_events("trackMinorEvent") && find_invalid_events("trackMajorEvent")
      end

      def find_invalid_events(base_string)
        valid_event = true

        invalid_objective_c_events = `grep '#{base_string}:@' -R Classes/`.split("\n")
        invalid_swift_events = `grep '#{base_string}("' -R Classes/`.split("\n")

        invalid_events = invalid_objective_c_events.concat invalid_swift_events

        invalid_events.each do |invalid_event|
          invalid = invalid_event.match(/#{base_string}:@".*"\s/).to_s.gsub(/#{base_string}:/, '')

          puts "Invalid minor event event: #{invalid}".colorize(:red)
          valid_event = false
        end

        return valid_event
      end
    end
  end
end
