class CreateTeas < ActiveRecord::Migration[7.1]
  def change
    create_table :teas do |t|
      t.references :subscription, null:false, foreign_key: true
      t.string :title
      t.string :description
      t.float :temperature
      t.integer :brew_time
      
      t.timestamps
    end
  end
end
