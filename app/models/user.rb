class User < ApplicationRecord
    has_many :posts
     validates :username, presence: true, uniqueness: { case_sensitive: false }
     validates :email, presence: true, uniqueness: {case_sensitive: false}
     validates :password, presence: true
end
