class CreateBattings < ActiveRecord::Migration
  def change
    create_table :battings do |t|
      t.string :playerID
      t.integer :yearID
      t.string :league
      t.string :teamID
      t.integer :G
      t.integer :AB
      t.integer :R
      t.integer :H
      t.integer :twoB
      t.integer :threeB
      t.integer :HR
      t.integer :RBI
      t.integer :SB
      t.integer :CS

      t.timestamps
    end
  end
end
