class CreateComplaints < ActiveRecord::Migration
  def change
    create_table :complaints do |t|
      t.string :subject
      t.text :matter
      t.string :key_words

      t.timestamps
    end
  end
end
