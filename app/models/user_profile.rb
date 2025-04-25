    # app/models/user_profile.rb
    class UserProfile < ApplicationRecord
      # /**********************************************************************/
      # /* START OF NEW CODE (Attach Avatar)                                */
      # /**********************************************************************/
      # Declare that a UserProfile can have one file attached, named :avatar
      # Active Storage handles the underlying storage mechanism.
      has_one_attached :avatar
      # /**********************************************************************/
      # /* END OF NEW CODE                                                    */
      # /**********************************************************************/

      # Add validation for username uniqueness (if not already added by scaffold index)
      validates :username, presence: true, uniqueness: true

      # You can add other validations here if needed, e.g., for bio length
    end
