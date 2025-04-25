class CreateSharedSchedules < ActiveRecord::Migration[8.0]
  def change
    create_table :shared_schedules do |t|
      t.string :share_token
      t.string :username
      t.string :schedule_name
      t.text :schedule_content

      t.timestamps
    end
    add_index :shared_schedules, :share_token, unique: true
  end
end
