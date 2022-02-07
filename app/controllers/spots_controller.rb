class SpotsController < ApplicationController

  def choice1
  end

  def chpice2
  end

  def index
    # 設問1,2の選択によって取得する観光地を分岐、ランダムに6件を表示
      #「自然」、「観たことのない景色を観てみたい」
      if    params[:choice1] == "0" && params[:choice2] == "0"
        @spot = Spot.tagged_with("鑑賞").order("RANDOM()").limit(6)
      #「自然」、「未踏の地を探検したい」
      elsif params[:choice1] == "0" && params[:choice2] == "1"
        @spot = Spot.tagged_with("散策").order("RANDOM()").limit(6)
      #「自然」、「いろいろな生き物と触れ合いたい」
      elsif params[:choice1] == "0" && params[:choice2] == "2"
        @spot = Spot.tagged_with(["動物園", "水族館","植物園","牧場","博物館"], :any => true).order("RANDOM()").limit(6)
      #「文化」、「人類の歴史を学び、美しい芸術に触れたい」
      elsif params[:choice1] == "1" && params[:choice2] == "0"
        @spot = Spot.tagged_with(["史料館", "美術館","博物館"], :any => true).order("RANDOM()").limit(6)
      #「文化」、「疲れた身体を休ませたい」
      elsif params[:choice1] == "1" && params[:choice2] == "1"
        @spot = Spot.tagged_with("温泉").order("RANDOM()").limit(6)
      #「文化」、「旅の想い出を手に入れたい」
      elsif params[:choice1] == "1" && params[:choice2] == "2"
        @spot = Spot.tagged_with("ショップ").order("RANDOM()").limit(6)
      end
    # /設問1,2の選択によって取得する観光地を分岐

  end

  # indexにて選択した画像と類似の画像を取得し提示することで、より最適な目的地を発見するためのアクション
  def similar
    # indexアクションにて選択した画像をGoogle Vision AI API に掛けて、ラベルを取得
    @spot  = Spot.find(params[:spot][:select])
    @tag   = Vision.get_image_data(@spot.image)
    # /indexアクションにて選択した画像をGoogle Vision AI API に掛けて、ラベルを取得

    # spotモデルから取得データを選別する。（@spotに格納された観光地と同類の観光地を取得）
      #「自然」、「観たことのない景色を観てみたい」
      if    params[:spot][:choice1] == "0" && params[:spot][:choice2] == "0"
        @spots = Spot.tagged_with("鑑賞")
      #「自然」、「未踏の地を探検したい」
      elsif params[:spot][:choice1] == "0" && params[:spot][:choice2] == "1"
        @spots = Spot.tagged_with("散策")
      #「自然」、「いろいろな生き物と触れ合いたい」
      elsif params[:spot][:choice1] == "0" && params[:spot][:choice2] == "2"
        @spots = Spot.tagged_with(["動物園", "水族館","植物園","牧場","博物館"], :any => true)
      #「文化」、「人類の歴史を学び、美しい芸術に触れたい」
      elsif params[:spot][:choice1] == "1" && params[:spot][:choice2] == "0"
        @spots = Spot.tagged_with(["史料館", "美術館","博物館"], :any => true)
      #「文化」、「疲れた身体を休ませたい」
      elsif params[:spot][:choice1] == "1" && params[:spot][:choice2] == "1"
        @spots = Spot.tagged_with("温泉")
      #「文化」、「旅の想い出を手に入れたい」
      elsif params[:spot][:choice1] == "1" && params[:spot][:choice2] == "2"
        @spots = Spot.tagged_with("ショップ")
      end
    # /spotモデルから取得データを選別する。（@spotに格納された観光地と同類の観光地を取得）

    # @spotsのデータをGoogle Vision AI API に掛けて、@spotに格納した観光地と類似の観光地を取得する。
    @similar_spot = []
    @spots.each do |spots|
      if Vision.get_image_data(spots.image).any?{ |spot| @tag.include? spot } == true
        Vision.get_image_data(spots.image)
        candidate_site = Spot.where(id: spots.id)
        @similar_spot  = @similar_spot.push(candidate_site)
      end
    end
     # /@spotsのデータをGoogle Vision AI API に掛けて、@spotに格納した観光地と類似の観光地を取得する。

    # 取得した類似の観光地のデータを最大5件までランダムに選び直す/
    @similar_spots = Spot.where(id: @similar_spot.flatten).where.not(id: @spot.id).order("RANDOM()").limit(5)

  end
  # /indexにて選択した画像と類似の画像を取得し提示することで、より最適な目的地を発見するためのアクション

  def show
    @spot  = Spot.find(params[:id])
    # @result = Geocoder.search([@spot.latitude, @spot.longitude])
    # 提案する経由地を取得：半径50km以内の観光地を最大6件取得し、選択した観光地自身は除外する＝最大5件表示
    @spots  = Spot.near([@spot.latitude, @spot.longitude], 50, units: :km).limit(6).to_a.delete_if{|spot| spot.id == @spot.id}
    @spots.sample(3)
  end

  def root
    @destination = Spot.find(params[:destination])
    # 経由地を設定した場合としなかった場合で分岐
    if params[:waypoint].empty? == false
      @waypoint     = Spot.find(params[:waypoint])
      gon.waypoint  = @waypoint
    end
    gon.destination = @destination
  end

end
