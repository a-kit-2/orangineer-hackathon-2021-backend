class CommentsController < ApplicationController
  def show
    event_id = params[:id]
    comments = Comment.where(event_id: event_id)

    if comments
      render json: { comments: comments }
    else
      render json: { message: "コメントを取得できません" }
    end
  end

  def create
    details = receiveBody
    comment = details[:comment]
    user = User.find(current_user.id)
    target = user.comments.new(comment)

    begin
      target.save!
      render json: {created_comment: true}
    rescue ActiveRecord::RecordInvalid => e
      puts e
      render json: {created_comment: false}
    end
  end

  def destroy
    comment_id = params[:id]
    target = Comment.find(comment_id)
    begin
      if target.user_id == current_user.id then
        target.destroy!
      else
        puts "投稿者以外は内容に変更を加えることができません"
      end
    rescue ActiveRecord::RecordInvalid => e
      puts e
      puts "削除に失敗しました"
    end
  end

  private
  def receiveBody
    JSON.parse(request.body.read, {:symbolize_names => true})
  end
end
