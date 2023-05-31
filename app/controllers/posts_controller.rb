class PostsController < ApplicationController

    def upload_post
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

            if @data[:post_title].empty? || @data[:post_content].empty?
                return render :json => {status: false, message: "Provide the valid data."}
            end

            user = User.find(decode_data["user_id"])

            @post = Post.new(post_title: @data[:post_title],post_content: @data[:post_content],user_id: user.id)
            @post.save()
            if @post 
                return render :json => {status: true, data: @post}
            end
        rescue => e
            return render :json => {status: false, msg: "Some error occurred."},:status => 500  
        end
    end
end