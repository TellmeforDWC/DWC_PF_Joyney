class Admin::SpotsController < ApplicationController

  def index
    @spots = Spot.all
    gon.spot = @spots
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
    gon.spot = @spot
  end

  def update
    @spot = Spot.find(params[:id])
    if @spot.update(spot_params)
      redirect_to admin_spots_path
    end
  end

  def destroy
  end

  private

  def spot_params
    params.require(:spot).permit(:spot_name, :image, :longitude, :latitude)
  end

end
