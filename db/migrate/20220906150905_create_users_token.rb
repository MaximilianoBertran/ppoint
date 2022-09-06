class CreateUsersToken < ActiveRecord::Migration[5.1]
  def change
    create_table :users_tokens do |t|
      t.belongs_to :user
      t.string :token, unique: true
      
      t.timestamps
    end
  end
end
