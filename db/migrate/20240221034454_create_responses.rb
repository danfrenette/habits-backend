class CreateResponses < ActiveRecord::Migration[7.1]
  def change
    create_table :responses, id: :uuid do |t|
      t.references :habit, null: false, foreign_key: true, type: :uuid
      t.string :description, null: false

      t.timestamps
    end
  end
end
