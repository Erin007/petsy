class ReviewsController < ApplicationController
  def new
    @review = Review.new
  end

  def create
    @review = Review.new

    @review.rating = params[:review][:rating]
    @review.title = params[:review][:rating]
    @review.description = params[:review][:description]

    #need to call flash[:notice] in views
    if @review.save
      flash[:notice] = "Review successfully created"
      redirect_to controller: 'products', action:'show', id: @review.product_id
    else
      flash[:notice] = @review.errors.messages.join(',')
      redirect_to product_reviews_new
    end

  end

  # def index
  # end

  # def show
  # end

  # def update
  # end

  # def edit
  # end

  # def destroy
  # end

end
