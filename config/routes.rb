Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"


  post "/user/register", to: "users#register"
  post "/user/login", to: "users#login"
  post "/user/get-user", to: "users#get_user"
  post "/user/upload-post", to: "posts#upload_post"
  post "/user/comment-post", to: "comments#send_comment"
  post "/user/like-post", to: "likes#send_like"
end
