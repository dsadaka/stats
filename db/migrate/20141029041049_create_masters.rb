class CreateMasters < ActiveRecord::Migration
  def change
    create_table :masters do |t|
      t.string :playerID
      t.integer :birthYear
      t.string :nameFirst
      t.string :nameLast

      t.timestamps
    end
  end
end
