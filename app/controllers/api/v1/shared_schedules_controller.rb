# app/controllers/api/v1/shared_schedules_controller.rb
class Api::V1::SharedSchedulesController < ApplicationController
  # We need SecureRandom to generate the unique token
  require "securerandom"
  # Skip CSRF token check for API requests (common practice for JSON APIs)
  skip_before_action :verify_authenticity_token, only: [ :create ], raise: false

  # POST /api/v1/schedules/share
  def create
    # 1. Get parameters from the request body sent by React
    # We expect JSON like: { username: "user1", schedule_name: "Fall 2025", schedule_content: "{...json...}" }
    username = params[:username]
    schedule_name = params[:schedule_name]
    schedule_content_json = params[:schedule_content] # This should be the JSON *string*

    # 2. Basic Validation
    if username.blank? || schedule_name.blank? || schedule_content_json.blank?
      render json: { error: "Missing required parameters: username, schedule_name, schedule_content" }, status: :bad_request
      return
    end

    # 3. Generate a unique token
    # Loop to ensure the generated token is truly unique, although collisions are highly unlikely
    token = nil
    loop do
      token = SecureRandom.hex(16) # Generates a 32-character hex string (e.g., "a1b2c3d4...")
      break unless SharedSchedule.exists?(share_token: token)
    end

    # 4. Create the database record
    shared_schedule = SharedSchedule.new(
      username: username,
      schedule_name: schedule_name,
      schedule_content: schedule_content_json, # Store the raw JSON string
      share_token: token
    )

    # 5. Save and Respond
    if shared_schedule.save
      # Construct the full URL the user can visit
      share_url = view_shared_schedule_url(share_token: shared_schedule.share_token)
      render json: { share_url: share_url }, status: :created
    else
      render json: { errors: shared_schedule.errors.full_messages }, status: :unprocessable_entity
    end

  rescue JSON::ParserError => e
     # Handle cases where schedule_content is not valid JSON
     render json: { error: "Invalid JSON format for schedule_content" }, status: :bad_request
  rescue => e # Catch other potential errors
     Rails.logger.error("Error creating share link: #{e.message}")
     Rails.logger.error(e.backtrace.join("\n"))
     render json: { error: "An unexpected error occurred while creating the share link." }, status: :internal_server_error
  end
end
