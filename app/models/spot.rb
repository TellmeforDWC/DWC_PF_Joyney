class Spot < ApplicationRecord

  attachment :image
  acts_as_taggable_on :tags

end
