class Admin::SpotsController < ApplicationController

  before_action :admin_authentication

  def index
    @spots = Spot.all.page(params[:page]).per(10)
    @tags = @spots.tag_counts_on(:tags)
  end

  def search
    # 検索フォームに何も入力しなかった場合
    if params[:keyword].empty? && params[:tag].empty?
      flash[:alert] = "検索条件を指定して下さい"
      redirect_to admin_spots_path
    # タグのみで検索する場合
    elsif params[:keyword].empty?
      @spot = Spot.tagged_with(params[:tag], :match_all => false).page(params[:page]).per(10)
      @tags = Spot.all.tag_counts_on(:tags)
    # 観光地名のみで検索する場合
    elsif params[:tag].empty?
      @spot = Spot.where("spot_name LIKE ?", "%#{params[:keyword]}%").page(params[:page]).per(10)
      @tags = Spot.all.tag_counts_on(:tags)
    # 観光地名とタグの両方で検索する場合
    else
      @spot = Spot.where("spot_name LIKE ?", "%#{params[:keyword]}%")
      @spot = @spot.tagged_with(params[:tag], :match_all => false).page(params[:page]).per(10)
      @tags = Spot.all.tag_counts_on(:tags)
    end
  end

  def new
    @spot = Spot.new
  end

  def create
    @spot = Spot.new(spot_params)

    if @spot.save
      redirect_to admin_spots_path
    end

  end

  def edit
    @spot = Spot.find(params[:id])
    @tags = @spot.tag_counts_on(:tags)
    gon.spot = @spot
  end

  def update
    @spot = Spot.find(params[:id])
    if @spot.update(spot_params)
      redirect_to admin_spots_path
    end
  end

  def destroy
    @spot = Spot.find(params[:id])
    @spot.destroy
    redirect_to admin_spots_path
  end

  private

  def spot_params
    params.require(:spot).permit(:spot_name, :image, :longitude, :latitude, :tag_list, :link)
  end

  def admin_authentication
    unless admin_signed_in?
      redirect_to choice1_spot_path
    end
  end

end
