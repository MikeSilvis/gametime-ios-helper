module Gametime
  module Helper
    class VerifyLocalization
      EXCEPTIONS = [
        "FAQ",
        "LocalNotifications",
        "Inflectors"
      ]

      def verify
        puts "verifying and removing unused localization strings".colorize(:blue)
        find_invalid_strings_and_remove ? (puts 'All Good'.colorize(:green)) : (puts 'Errors Occured'.colorize(:red))

        puts "Verifying all strings in code have matching localization string".colorize(:blue)
        verify_all_strings_present ? (puts 'All Good'.colorize(:green)) : (puts 'Errors Occured'.colorize(:red))
      end

      def verify_all_strings_present
        valid_lines = []

        File.open('./Resources/Base.lproj/Localizable.strings').each do |line|
          if line.start_with?('"')
            valid_lines << line.match(/^"\S*/).to_s
          end
        end

        results = `grep "StringsManager.sharedInstance().stringForID" -R Classes/`.split("\n")
        results.concat `grep "GTStr" -R Classes/`.split("\n")

        valid_event = true

        results.each do |result|
          if matched_output = result.match(/stringForID\("\S*"/)
            matched_output = matched_output.to_s.gsub(/stringForID\(/, '')

            exception_found = false
            EXCEPTIONS.each do |exception|
              if matched_output.match(/#{exception}/)
                exception_found = true
              end
            end

            if !valid_lines.include?(matched_output) && !exception_found
              puts "missing key: #{matched_output}"
              valid_event = false
            end
          end

          if matched_output = result.match(/GTStr\("\S*"/)
            matched_output = matched_output.to_s.gsub(/GTStr\(/, '')

            exception_found = false
            EXCEPTIONS.each do |exception|
              if matched_output.match(/#{exception}/)
                exception_found = true
              end
            end


            if !valid_lines.include?(matched_output) && !exception_found
              puts "missing key: #{matched_output}"
              valid_event = false
            end
          end
        end

        valid_event
      end

      def find_invalid_strings_and_remove
        valid_event = true
        valid_localization = []
        file_path = './Resources/Base.lproj/Localizable.strings'

        File.open(file_path).each do |line|
          exception_found = false

          EXCEPTIONS.each do |exception|
            if line.match(/#{exception}/i)
              exception_found = true
            end
          end

          if line.start_with?('"') && !exception_found
            localizable_string_name = line.match(/^"\S*/)
            search_results = `grep "#{localizable_string_name}" -R Classes/ | grep -v "Localizable.strings"`

            if search_results.to_s == ""
              valid_event = false
              puts "Unused Localizable String: #{localizable_string_name}"
            else
              valid_localization << line
            end
          else
            valid_localization << line
          end
        end

        File.open(file_path, 'w') { |file| file.write(valid_localization.join("")) }

        return valid_event
      end
    end
  end
end
