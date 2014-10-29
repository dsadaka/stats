class CreatePitchings < ActiveRecord::Migration
  def change
    create_table :pitchings do |t|
      t.string :playerID
      t.integer :yearID
      t.string :league
      t.string :teamID

      t.timestamps
    end
  end
end
