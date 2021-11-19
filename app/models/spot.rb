class Spot < ApplicationRecord

  attachment :image
  acts_as_taggable_on :tags
  reverse_geocoded_by :latitude, :longitude

end
