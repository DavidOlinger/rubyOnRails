    # app/helpers/shared_schedules_helper.rb
    module SharedSchedulesHelper
      # Helper method to format the start and end times of an event
      # Takes the time hash (e.g., { startTime: 32400, endTime: 35400 })
      # Returns an array [start_string, end_string] or ['N/A', 'N/A']
      def format_event_time(time_data)
        # Check if time_data and necessary keys exist
        unless time_data && time_data[:startTime] && time_data[:endTime]
          return [ "N/A", "N/A" ]
        end

        begin
          # Assume startTime and endTime are seconds since midnight UTC
          start_seconds = time_data[:startTime].to_i
          end_seconds = time_data[:endTime].to_i

          # Create Time objects assuming they represent times on a generic day
          # Add them to the beginning of the Unix epoch (Jan 1, 1970 UTC)
          start_time = Time.at(start_seconds).utc
          end_time = Time.at(end_seconds).utc

          # Format as H:MM AM/PM (e.g., 9:00 AM)
          # %l = hour, space-padded ( 1..12)
          # %M = minute (00..59)
          # %p = AM/PM
          # .strip removes leading space for single-digit hours
          start_str = start_time.strftime("%l:%M %p").strip
          end_str = end_time.strftime("%l:%M %p").strip

          [ start_str, end_str ]
        rescue => e
          # Log error if time conversion fails
          Rails.logger.error("Error formatting time in helper: #{e.message} for data: #{time_data.inspect}")
          [ "Error", "Error" ]
        end
      end
    end
