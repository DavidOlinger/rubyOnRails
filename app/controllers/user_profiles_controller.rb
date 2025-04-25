# app/controllers/user_profiles_controller.rb
class UserProfilesController < ApplicationController
  # Find the user profile by username before executing show, update, or destroy
  before_action :set_user_profile, only: [ :show, :update, :destroy ]
  # Skip CSRF token check for API requests (common practice for JSON APIs)
  skip_before_action :verify_authenticity_token, only: [ :create, :update, :destroy ], raise: false


  # GET /user_profiles
  # Returns all profiles (consider removing or adding pagination if list gets large)
  def index
    @user_profiles = UserProfile.all
    # Include avatar URL if attached
    render json: @user_profiles.map { |profile| profile_json(profile) }
  end

  # GET /user_profiles/:username
  # Returns a specific profile identified by username
  def show
    # @user_profile is set by the before_action
    # Include avatar URL if attached
    render json: profile_json(@user_profile)
  end

  # POST /user_profiles
  # Creates a new profile
  def create
    # Ensure we don't try to create if one already exists for the username
    existing_profile = UserProfile.find_by(username: user_profile_params[:username])
    if existing_profile
      render json: { errors: { username: [ "has already been taken" ] } }, status: :unprocessable_entity
      return
    end

    @user_profile = UserProfile.new(user_profile_params)
    if @user_profile.save
      # Use the helper to include avatar URL in the response
      render json: profile_json(@user_profile), status: :created, location: user_profile_url(@user_profile.username)
    else
      render json: @user_profile.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user_profiles/:username
  # Updates an existing profile identified by username
  def update
    # @user_profile is set by the before_action
    # Prevent changing the username via update if desired
    update_params = user_profile_params
    update_params.delete(:username) if update_params.key?(:username) # Optionally prevent username change

    if @user_profile.update(update_params)
      # Use the helper to include avatar URL in the response
      render json: profile_json(@user_profile)
    else
      render json: @user_profile.errors, status: :unprocessable_entity
    end
  end

  # DELETE /user_profiles/:username
  # Deletes a profile identified by username
  def destroy
    # @user_profile is set by the before_action
    @user_profile.destroy! # Use destroy! to raise an error on failure
    head :no_content # Return 204 No Content on success
  end

  private
    # Finds the user profile based on the :username parameter from the URL.
    # Note: Rails routing with 'param: :username' makes params[:username] available.
    # If you didn't use param:, it would be params[:id] containing the username.
    def set_user_profile
      # Use the correct parameter key based on your routes.rb
      profile_identifier = params[:username] || params[:id]
      @user_profile = UserProfile.find_by(username: profile_identifier)

      # Render 404 if the profile isn't found
      unless @user_profile
        render json: { error: "UserProfile not found for username: #{profile_identifier}" }, status: :not_found
      end
    end

    # Defines the permitted parameters for creating/updating a profile (Strong Parameters)
    def user_profile_params
      # Ensure the incoming parameters are nested under :user_profile key
      # Permit the :avatar parameter for file uploads
      params.require(:user_profile).permit(:username, :bio, :profile_pic_url, :favorite_spot, :avatar)
    end

    # Helper method to generate JSON including the avatar URL if present
    def profile_json(profile)
      # Use Active Storage's #url helper if the avatar is attached and persisted
      avatar_url = if profile&.avatar&.attached? && profile.avatar.persisted?
                     # Generate a URL that works with the default disk service proxy
                     # This generates a relative path by default in development
                     url_for(profile.avatar)
      else
                     nil
      end

      # Return profile attributes plus the avatar URL (relative path in dev)
      profile.as_json(except: [ :created_at, :updated_at ]).merge(avatar_url: avatar_url)
    end
end
