ActiveRecord::Schema.define do
  create_table(:dummies, force: true) do |t|
    t.string :name
    t.timestamps
  end
end
