require 'activerecord-tableless'

class Dummy < ActiveRecord::Base
  has_no_table

  column :name, :string
end