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
    # お気に入りボタンをクリックしたら、その駅のidをユーザのDBレコードに登録する
    favst_id = params.permit(:station_id)
    # 既存のidがあればidを更新する
    current_user.station_id = favst_id
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
