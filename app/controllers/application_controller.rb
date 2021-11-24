class ApplicationController < ActionController::Base

  def after_sign_in_path_for(resource)
    admin_spots_path # ログイン後に遷移するpathを設定
  end

  def after_sign_out_path_for(resource)
    choice1_spot_path # ログアウト後に遷移するpathを設定
  end

end
