require "gametime/helper/version"

module Gametime
  module Helper
    def self.verify
      VerifyTracking.new.verify
      VerifyLocalization.new.verify
    end

    class VerifyTracking
      def verify
        puts "verifying and removing unused localization strings\n\n"
        find_invalid_strings_and_remove

        puts "verifying all strings in code have matching localization string\n\n"
        verify_all_strings_present
      end

      def verify_all_strings_present
        valid_lines = []

        File.open('./Resources/Base.lproj/Localizable.strings').each do |line|
          if line.start_with?('"')
            valid_lines << line.match(/^"\S*/).to_s
          end
        end

        results = `grep "stringForID" -R Classes/`.split("\n")
        results.concat `grep "GTStr" -R Classes/`.split("\n")

        all_strings_used = true

        results.each do |result|
          if matched_output = result.match(/stringForID\("\S*"/)
            matched_output = matched_output.to_s.gsub(/stringForID\(/, '')

            unless valid_lines.include?(matched_output)
              puts "missing key: #{matched_output}"
              all_strings_used = false
            end
          end

          if matched_output = result.match(/GTStr\("\S*"/)
            matched_output = matched_output.to_s.gsub(/GTStr\(/, '')

            unless valid_lines.include?(matched_output)
              puts "missing key: #{matched_output}"
              all_strings_used = false
            end
          end
        end

        if all_strings_used
          puts 'All strings are used and accounted for'
        end
      end

      def find_invalid_strings_and_remove
        valid_localization = []
        file_path = './Resources/Base.lproj/Localizable.strings'

        File.open(file_path).each do |line|
          if line.start_with?('"')
            localizable_string_name = line.match(/^"\S*/)
            search_results = `grep "#{localizable_string_name}" -R Classes/ | grep -v "Localizable.strings"`

            if search_results.to_s == ""
              puts "Unused Localizable String: #{localizable_string_name}"
            else
              valid_localization << line
            end
          else
            valid_localization << line
          end
        end

        File.open(file_path, 'w') { |file| file.write(valid_localization.join("")) }
      end

    end

    class VerifyLocalization
      def verify
        puts "verifying tracking events\n\n"
        verify_no_missing_tracking_events
      end
      def verify_no_missing_tracking_events
        File.open('./Classes/GAMTrackingEvents.h').each do |line|
          if line.start_with?('static')
            tracking_event_name = line.match(/kTracking(\w*)/)
            search_results = `grep "#{tracking_event_name}" -R Classes/ | grep -v "GAMTrackingEvents.h"`

            if search_results.to_s == ""
              puts "Missing Event: #{tracking_event_name}"
            end
          end
        end
      end

    end
  end
end
