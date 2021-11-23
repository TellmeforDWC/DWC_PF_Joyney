class SpotsController < ApplicationController

  def choice1
  end

  def chpice2
  end

  def index
    # 設問1,2の選択によって取得する観光地を分岐
      #「自然」、「観たことのない景色を観てみたい」
      if    params[:choice1] == "0" && params[:choice2] == "0"
        @spot = Spot.tagged_with("鑑賞")
      #「自然」、「未踏の地を探検したい」
      elsif params[:choice1] == "0" && params[:choice2] == "1"
        @spot = Spot.tagged_with("散策")
      #「自然」、「いろいろな生き物と触れ合いたい」
      elsif params[:choice1] == "0" && params[:choice2] == "2"
        @spot = Spot.tagged_with(["動物園", "水族館","植物園","牧場","博物館"], :any => true)
      #「文化」、「人類の歴史を学び、美しい芸術に触れたい」
      elsif params[:choice1] == "1" && params[:choice2] == "0"
        @spot = Spot.tagged_with(["史料館", "美術館","博物館"], :any => true)
      #「文化」、「疲れた身体を休ませたい」
      elsif params[:choice1] == "1" && params[:choice2] == "1"
        @spot = Spot.tagged_with("温泉")
      #「文化」、「旅の想い出を手に入れたい」
      elsif params[:choice1] == "1" && params[:choice2] == "2"
        @spot = Spot.tagged_with("ショップ")
      end
    # /設問1,2の選択によって取得する観光地を分岐

  end

  def show
    @spot   = Spot.find(params[:id])
    @result = Geocoder.search([@spot.latitude, @spot.longitude])
    # 提案する経由地を取得：半径50km以内の観光地を最大6件取得し、選択した観光地自身は除外する＝最大5件表示
    @spots  = Spot.near([@spot.latitude, @spot.longitude], 50, units: :km).limit(6).to_a.delete_if{|spot| spot.id == @spot.id}
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
