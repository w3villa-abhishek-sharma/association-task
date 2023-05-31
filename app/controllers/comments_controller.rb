class CommentsController < ApplicationController

    def send_comment
        begin
            @data = params
            token = request.headers["token"]
            if(!token)
                return render :json => {status: false, msg: "unauthorized access"},:status => 401  
            end

            begin
                decode_data = JWT.decode(token,"secret")[0]
                if(decode_data["exp"] < Time.now.to_i)
                    return render :json => {status: false, msg: "Invalid token."},:status => 400  
                end
            rescue => e
                return render :json => {status: false, msg: "Invalid token."},:status => 400  
            end

            if @data[:post_id].empty? || @data[:comment].empty?
                return render :json => {status: false, message: "Provide the valid data."}
            end

            user = User.find(decode_data["user_id"])

            @comment = Comment.new(post_id: @data[:post_id],comment: @data[:comment],user_id: user.id)
            @comment.save()
            if @comment 
                return render :json => {status: true, data: @comment}
            end
        rescue => e
            return render :json => {status: false, msg: "Some error occurred."},:status => 500  
        end
    end
end