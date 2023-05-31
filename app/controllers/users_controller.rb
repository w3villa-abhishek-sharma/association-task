class UsersController < ApplicationController

    # Register User
    def register
        begin
            @data = params
            if @data[:email].empty? || @data[:username].empty? || @data[:password].empty?
                return render :json => {status: false, message: "Provide the valid data."}
            end
            @user_exist = User.find_by(username: @data[:username].downcase())
            if(@user_exist)
                return render :json => {status: false, msg: "user already exist."}
            end

            @user = User.new(username: @data[:username].downcase(), password: @data[:password],email: @data[:email])
            @user.save()
            if @user 
                return render :json => {status: true, data: @user.as_json({except: [:password, :token]})}
            end
        rescue => e
            return render :json => {status: false, msg: "Some error occurred."},:status => 500  
        end
    end


    # Login User
    def login
        begin
            @data = params
            if @data[:username].empty? || @data[:password].empty?
                return render :json => {status: false, message: "Provide the valid data."}
            end

            @user_exist = User.find_by(username: @data[:username].downcase())
            if(!@user_exist)
                return render :json => {status: false, msg: "user not register"}
            end

            if @user_exist[:password] == @data[:password]
                payload = {
                    username: @user_exist[:username],
                    user_id: @user_exist[:id],
                    exp: Time.now.to_i + (24 * 60 * 60)
                }
                token = JWT.encode(payload,'secret','HS256');
                @user_exist[:token] = token
                @user_exist.save()
                return render :json => {status: true, token: token}
            else
                return render :json => {status: false, msg: "Invalid usernae or password."},:status => 400  
            end

        rescue => e
            return render :json => {status: false, msg: "Some error occurred."},:status => 500  
        end
    end


    def get_user
        begin
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
            
            user = User.find(decode_data["user_id"])
            if(!user)
                return render :json => {status: false, msg: "User not exist."}
            end
            p user["token"]
            p token
            if user["token"] == token
                return render :json => {status: true, data: user.as_json({except: [:password, :token]})}
            else
                return render :json => {status: false, msg: "unauthorized access"},:status => 401
            end
        rescue => e
            return render :json => {status: false, msg: "Some error occurred."},:status => 500  
        end
    end
end
