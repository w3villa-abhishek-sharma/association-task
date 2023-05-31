class LikesController < ApplicationController

    def send_like
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

            if @data[:type].empty?
                return render :json => {status: false, message: "Provide the valid data."}
            end

            user = User.find(decode_data["user_id"])
            

            if(@data[:type] == "post")
                @like = Like.new(like_type: @data[:type],post_id: @data[:liked_id],comment_id: nil,user_id: user.id)
            else
                @like = Like.new(like_type: @data[:type],comment_id: @data[:liked_id],post_id: nil,user_id: user.id)
            end
            debugger 
            
            if @like.save() 
                return render :json => {status: true, data: @like}
            end
        rescue => e
            return render :json => {status: false, msg: "Some error occurred."},:status => 500  
        end
    end
end