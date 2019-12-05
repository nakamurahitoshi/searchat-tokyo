class UsersController < ApplicationController
  # ユーザー情報編集画面を表示するeditアクション
  def edit
  end

  # ユーザ情報を変更するupdateアクション
  def update
     # current_userに対して更新nが成功したらルートに戻り、
    # そうでなければ編集画面に戻る
    if current_user.update(user_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  # ユーザのお気に入り駅を登録するcreateアクション
  def create
    params.permit(:station_id, :flag)
    # お気に入り駅のIDを取得
    station_id = params[:station_id]
    # フラグにより、お気に入り登録(フラグ0)/解除(フラグ1)を分ける
    if params[:flag].to_i == 0
      # お気に入り登録操作
      # ログイン中のユーザのお気に入り駅を更新する
      current_user.station_id = station_id
      # お気に入り駅を取得
      @favorite_station = Station.find(station_id)
    elsif params[:flag].to_i == 1
      # お気に入り解除操作
      # ログイン中のユーザのお気に入り駅idをnilにする
      current_user.station_id = nil
      # お気に入り駅にnilを代入
      @favorite_station = nil
    end
    current_user.save
    # リクエストに応じて処理を分ける
    respond_to do |format|
      format.html
      format.json 
    end
  end

  private
  def user_params
   params.require(:user).permit(:name, :email)
  end
end
