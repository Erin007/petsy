class User < ActiveRecord::Base
  has_many :products
  has_many :orders
  validates_presence_of :name

  # validate :email_at_symbol, :provider, :email, :uid, :authenticated
  # validate :avatar_url

  def self.build_from_github(auth_hash)
    user       = User.new
    user.uid   = auth_hash[:uid]
    user.provider = 'github'
    user.name  = auth_hash['info']['name']
    user.username  = auth_hash['info']['name']
    user.email = auth_hash['info']['email']
    user.avatar = auth_hash['extra']['raw_info']['avatar_url']
    user.authenticated = true

    return user
  end

  def email_at_symbol
    if self.email != nil
      unless self.email.include?("@")
        errors.add(:email, "Email address must include @")
      end
    end
  end

  def avatar_url
    if self.avatar != nil && !self.avatar.include?(".com")
      errors.add(:avatar, "Avatar link must be a .com url")
    end
  end

  def average_rating
    #Find all of the products sold by this seller
    products = self.products
    #Find all of the reveiws for all of the products sold by this seller
    if products.length > 0
      reviews = []
      products.each do |product|
        reviews << product.reviews
      end
      #Find all of the ratings for all of those reviews
      ratings = []
      reviews.flatten.each do |review|
        ratings << review.rating.to_f
      end
    end
    #Sum all of the ratings and divide the sum by the number of ratings
    if ratings.length > 0
      average = ratings.reduce(:+)/ratings.length
    end

    return average.round
  end
end
