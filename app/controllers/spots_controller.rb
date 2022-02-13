class SpotsController < ApplicationController

  def choice1
  end

  def chpice2
  end

  def index
    @spot = Spot.question(params[:choice1], params[:choice2])
  end

  # indexにて選択した観光地と類似の観光地を取得し再提示することで、より最適な目的地を発見するためのアクション
  def similar
    # indexアクションにて選択した画像をGoogle Vision AI API に掛けて、ラベルを取得
    @spot  = Spot.find(params[:spot][:select])
    @tag   = Vision.get_image_data(@spot.image)

    # Spotモデルから取得データを選別する。（@spotに格納された観光地と同カテゴリの観光地を取得）
    @spots = Spot.question(params[:spot][:choice1], params[:spot][:choice2])

    # @spotsの観光地をGoogle Vision AI API に掛け、@spotのラベル（@tag）に一致した（=類似の）観光地データを取得する。
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
