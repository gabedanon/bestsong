class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :for_id
      t.integer :against_id

      t.timestamps
  	remove_column :songs, :vote_for
  	remove_column :songs, :vote_against
    end
  end
end
