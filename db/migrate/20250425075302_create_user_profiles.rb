class CreateUserProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :user_profiles do |t|
      t.string :username
      t.text :bio
      t.string :profile_pic_url
      t.string :favorite_spot

      t.timestamps
    end
    add_index :user_profiles, :username, unique: true
  end
end
