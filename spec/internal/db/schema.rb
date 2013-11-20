ActiveRecord::Schema.define do
  create_table(:dummies, force: true) do |t|
    t.string     :name
    t.boolean    :will_invalidate, null: false, default: false
    t.timestamps
  end
end
