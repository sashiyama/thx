class CreateGivingHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :giving_histories do |t|
      t.date :giving_date

      t.timestamps
    end
  end
end
