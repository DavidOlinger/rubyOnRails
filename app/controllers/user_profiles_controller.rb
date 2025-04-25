# app/controllers/user_profiles_controller.rb
class UserProfilesController < ApplicationController
  # Find the user profile by username before executing show, update, or destroy
  before_action :set_user_profile, only: [ :show, :update, :destroy ]

  # GET /user_profiles
  # Returns all profiles (consider removing or adding pagination if list gets large)
  def index
    @user_profiles = UserProfile.all
    render json: @user_profiles
  end

  # GET /user_profiles/:username
  # Returns a specific profile identified by username
  def show
    # @user_profile is set by the before_action
    render json: @user_profile
  end

  # POST /user_profiles
  # Creates a new profile
  def create
    @user_profile = UserProfile.new(user_profile_params)

    if @user_profile.save
      render json: @user_profile, status: :created, location: user_profile_url(@user_profile.username) # Use username for location
    else
      render json: @user_profile.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user_profiles/:username
  # Updates an existing profile identified by username
  def update
    # @user_profile is set by the before_action
    if @user_profile.update(user_profile_params)
      render json: @user_profile
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
      # Adjust parameter key if necessary based on routes.rb (:id vs :username)
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
      params.require(:user_profile).permit(:username, :bio, :profile_pic_url, :favorite_spot)
    end
end
