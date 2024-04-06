class CreateRecurrenceRules < ActiveRecord::Migration[7.1]
  def change
    create_table :recurrence_rules, id: :uuid do |t|
      t.string :rrule, null: false
      t.references :task, null: false, foreign_key: true, type: :uuid, index: true

      t.timestamps
    end
  end
end
