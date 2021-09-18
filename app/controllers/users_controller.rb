class UsersController < ApplicationController
  def show
    user_id = params[:id]
    begin
      user = User.find(user_id)
      render json: { 
        user_found: true,
        user: user
      }
    rescue => exception
      render json: {
        user_found: false,
        user: user
      }
    end
  end

  # サインイン、サインアップ処理
  def signin
    @user = User.find_by(sub: registrations_params[:sub])
  
    if @user
      signin! #セッションにユーザー情報を置く
      render json: { status: :created, signed_in: true, user: @user }
    else
      @user = User.create(registrations_params)
      signin! #セッションにユーザー情報を置く
      render json:{ status: :create_now, signed_in: true, user: @user }
    end
  end

  #サインアウト処理
  def signout
    reset_session
  end

  #サインイン中か確認
  def signed_in
    if current_user
      render json: { signed_in: true, user: current_user }
    else
      render json: { signed_in: false, message: 'ユーザーが存在しません' }
    end
  end

  #興味あるイベントを登録する
  def like
    user_id = params[:id]
    like_events = Event.includes(:users).where(users: {id: user_id})

    like_users = like_events.each_with_object([]) do |event, arr|
      users = User.find(event.user_id)
      arr.push(users)
    end

    like_users.flatten!
    like_users.uniq!


    events = Event.where(user_id: user_id)

    liked_users = events.each_with_object([]) do |event, arr|
      users = User.includes(:events).where(events: {id: event.id}).order(id: :asc)
      arr.push(users)
    end

    liked_users.flatten!
    liked_users.uniq!


    if like_users || liked_users
      render json: { 
        like_users: like_users,
        liked_users: liked_users
      }
    else
      render json: { message: "関連するユーザーがいません" }
    end

  end

  def save_settings
    begin
      user = User.find(current_user.id)
      user.update!(users_params)
      render json: { content_updated: true }
    rescue => exception
      render json: { content_updated: false }
    end
  end

  private
  def users_params
    params.require(:user).permit(:content)
  end

  def registrations_params
    params.require(:user).permit(:name, :email, :content, :image_url, :sub)
  end 
  # # before_action :authenticate_user
  # def index
  #   render json: {
  #     message: "ID: #{current_user.id}, SUB: #{current_user.sub}"
  #   }
  # end
end
