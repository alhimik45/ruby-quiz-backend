class CreateAskStatistics < ActiveRecord::Migration
  def change
    create_table :ask_statistics do |t|
      t.integer :askId
      t.integer :rightCount, default: 0
      t.integer :wrongCount, default: 0

      t.timestamps null: false
    end
  end
end
