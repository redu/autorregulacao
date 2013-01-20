class Space < ActiveRecord::Base
  attr_accessible :name
  has_many :ar_exercises
end
