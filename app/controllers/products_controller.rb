class ProductsController < ApplicationController
  def product
    @product ||= Product.find(params[:id].to_i)
  end

  def new
    if session[:user_id] != nil
      @product = Product.new
      @product.categories.new
    else
      redirect_to root_path
    end
  end

  def create
    @product = Product.new(product_params)

    #If product saves successfully, convert price to cents, delete blank Category if created, and redirect to show the new product
    if @product.save
      @product.price *= 100
      @product.save
      if Category.exists?(name:"")
        blank = Category.find_by(name:"")
        blank.destroy
      end
      redirect_to action: "show", id: @product.id

    #If the product fails to save, redirect the user back to the new product page to try again and display error messages
    else
      flash[:notice] = @product.errors.full_messages
      redirect_to new_product_path
    end
  end

  def index
    @categories = Category.all

    #If a search is submitted
    if params[:commit] == "search"
      #If the user does a non-blank search
      if !params[:q].blank?
        @products = Product.ransack(params[:q]).result
      end

    #If a category_id is passed via the products page (by clicking on a category)
    elsif !params[:category_id].blank?
      @products = Category.find(params[:category_id]).products

    #If a user goes to the Products page without search or category selection
    else
      @products = Product.all
    end
  end

  def by_merchant
    #ONLY WANT MERCHANTS THAT HAVE ACTIVE ITEMS
    @merchants = User.all

    if !params[:merchant_id].blank?
      @products = User.find(params[:merchant_id]).products
    else
      @products = Product.all
    end
  end

  def show
    @product = Product.find(params[:id].to_i)
    @reviews = Review.where(product_id: params[:id].to_i)

    @current_user = current_user
    @order = Order.find_by(buyer_id: @current_user.id, status: "pending") # If the current user already has a pending order, just add to that
    if @order.nil?
      @order = Order.new(buyer_id: @current_user.id)
    end
    @orderproduct = OrderProduct.find_by(order_id: @order.id, product_id: @product.id)
    if @orderproduct.nil?
      @orderproduct = OrderProduct.new(order_id: @order.id, product_id: @product.id, quantity: 0)  #this isn't really necessary, but this gives the quantity field in the form
    end
    @order.save
    @orderproduct.save
  end

  def update
    product
    @product.update(product_params)

    if @product.save
      @product.price *= 100
      @product.save
      if Category.exists?(name:"")
        blank = Category.find_by(name:"")
        blank.destroy
      end
      redirect_to action: "show", id: @product.id
    else
      flash[:notice] = @product.errors.full_messages
      redirect_to edit_product_path(id: @product.id)
    end
  end

  def edit
    product

    #Makes sure only the product seller can edit the product and changes product price to dollars for the edit form (switches back to cents via update method)
    if session[:user_id] == @product.user_id
      @product.price /= 100
      @product.save
      @product.categories.new
    else
      redirect_to root_path
    end
  end

  def destroy
    product.destroy
    redirect_to user_path(product.user_id)
  end

  def activation
    if product.active == true
      product.update_attribute(:active, false)
    else
      product.active == false
      product.update_attribute(:active, true)
    end
    redirect_to :back
  end

# book.update_attribute(:votes, (book.votes + 1))

private
   def product_params
     params.require(:product).permit(:name, :user_id, :price, :quantity, :description, :picture, :active, categories_attributes: [:name], category_ids: [])
   end

   def current_user
     if session[:user_id] != nil
       user = User.find(session[:user_id])
     elsif session[:guest_id] != nil
       user = User.find(session[:guest_id])
     else
       user = User.new(name: "Guest", authenticated: false)
       user.save
       session[:guest_id] = user.id
     end
     return user
   end
end
