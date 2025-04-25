# app/controllers/shared_schedules_controller.rb
# Change ApplicationController to ActionController::Base to enable full view rendering
class SharedSchedulesController < ActionController::Base
  require "json"

  # /**********************************************************************/
  # /* START OF MODIFICATION (Remove Layout Directive)                    */
  # /**********************************************************************/
  # Remove or comment out the layout line, as the default layout doesn't exist in API mode
  # layout 'application', only: [:show]
  # /**********************************************************************/
  # /* END OF MODIFICATION                                                */
  # /**********************************************************************/


  # GET /s/:share_token
  def show
    # Debug log from previous step (can be removed later)
    puts "\n\n--- !!! DEBUG: Reached SharedSchedulesController#show Action !!! ---\n\n"
    Rails.logger.info("--- !!! DEBUG: Reached SharedSchedulesController#show Action !!! ---")

    token = params[:share_token]
    Rails.logger.info("--- Looking for token: #{token} ---")
    @shared_schedule = SharedSchedule.find_by(share_token: token)

    unless @shared_schedule
      Rails.logger.warn("--- Token '#{token}' not found in database ---")
      render plain: "Schedule not found.", status: :not_found
      return
    end

    Rails.logger.info("--- Found shared schedule record for user: #{@shared_schedule.username} ---")

    begin
      Rails.logger.info("--- Parsing schedule content ---")
      @schedule_data = JSON.parse(@shared_schedule.schedule_content || "{}", symbolize_names: true)
      @schedule_data[:events] ||= []
      Rails.logger.info("--- Parsed schedule content successfully ---")
    rescue JSON::ParserError => e
      Rails.logger.error("Error parsing stored schedule content for token #{token}: #{e.message}")
      @error_message = "Could not display schedule: Invalid data format."
      @schedule_data = { name: @shared_schedule.schedule_name, events: [] }
    end

    Rails.logger.info("--- Rendering show.html.erb ---")
    # By inheriting from ActionController::Base and NOT specifying a layout,
    # Rails will now implicitly render app/views/shared_schedules/show.html.erb
    # directly and return status 200 OK.
  end
end
