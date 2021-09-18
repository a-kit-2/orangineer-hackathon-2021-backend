class EventsController < ApplicationController
  #event投稿
  def create
    event = receiveBody[:event]
    event[:user_id] = current_user.id
    new_event = Event.new(event)

    begin
      new_event.save!
      render json: {event_created: true}
    rescue => exception
      render json: {event_created: false}
    end
  end

  #イベント一覧
  def index
    events = Event.includes(:user).order(created_at: :desc)
    render json: {
      events: build_events(events)
    }
  end

  #イベント詳細
  def show
    begin
      event = Event.includes(:user).find(params[:id])
      render json: { event: build_events([event])[0], found: true}
    rescue => exception
      render json: { found: false }
    end
  end

  #イベント削除
  def destroy
    event_id = params[:id]
    begin
      delete_event = Event.find(event_id)
      delete_event.destroy!
      render json: {event_deleted: true}
    rescue => exception
      render json: {event_deleted: false}
    end
  end

  def interest
    # event_id でイベントを取得
    # current_user.id でユーザーを取得
    event_id = params[:id]
    user_id = current_user.id
    target = Joinning.new(
      event_id: event_id,
      user_id: user_id
    )

    begin
      target.save!
      render json: {create_joinning: true}
    rescue => e
      p e
      render json: {create_joinning: false}
    end
  end

  private 
  #eventsを一つずつ欲しい形に書き換え
  def build_events(events)
    events.each_with_object([]) do |event, arr|
      # << は配列の末尾に追加するもの（ただし、一つしかいれられない=>複数追加したい場合、pushを使えばいい）
      arr << event_content(event)
    end
  end

  #オブジェクトの内容を書き換え
  def event_content(event)
    {
      id: event.id,
      user_id: event.user.id,
      user_img: event.user.image_url,
      title: event.title,
      content: event.content,
      reward: event.reward,
      map_url: event.map_url,
      images: event.users.map { |user| { image_url: user.image_url} },
      isDeleted: event.isDeleted,
      created_at: event.created_at,
      updated_at: event.updated_at,
    }
  end

  def receiveBody
    JSON.parse(request.body.read, {:symbolize_names => true})
  end
end
