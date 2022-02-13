class Spot < ApplicationRecord

  attachment :image
  acts_as_taggable_on :tags
  reverse_geocoded_by :latitude, :longitude

  def self.question(choice1, choice2)     # 設問1,2の選択によって取得する観光地を分岐、ランダムに6件を表示
      #「自然」、「観たことのない景色を観てみたい」
      if    choice1 == "0" && choice2 == "0"
        self.tagged_with("鑑賞").order("RANDOM()").limit(6)
      #「自然」、「未踏の地を探検したい」
      elsif choice1 == "0" && choice2 == "1"
        self.tagged_with("散策").order("RANDOM()").limit(6)
      #「自然」、「いろいろな生き物と触れ合いたい」
      elsif choice1 == "0" && choice2 == "2"
        self.tagged_with(["動物園", "水族館","植物園","牧場","博物館"], :any => true).order("RANDOM()").limit(6)
      #「文化」、「人類の歴史を学び、美しい芸術に触れたい」
      elsif choice1 == "1" && choice2 == "0"
        self.tagged_with(["史料館", "美術館","博物館"], :any => true).order("RANDOM()").limit(6)
      #「文化」、「疲れた身体を休ませたい」
      elsif choice1 == "1" && choice2 == "1"
        self.tagged_with("温泉").order("RANDOM()").limit(6)
      #「文化」、「旅の想い出を手に入れたい」
      elsif choice1 == "1" && choice2 == "2"
        self.tagged_with("ショップ").order("RANDOM()").limit(6)
      end
  end

end
