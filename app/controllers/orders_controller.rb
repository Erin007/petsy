class OrdersController < ApplicationController

  def new

  end

  def create
    @current_user = current_user
    @order = Order.find_by(buyer_id: @current_user.id, status: "pending") # If the current user already has a pending order, just add to that
    if @order.nil?
      @order = Order.new(buyer_id: @current_user.id, status: "pending") # status of the order ("pending", "paid", "complete", "cancelled")
    end

    @orderproduct = OrderProduct.find_by(order_id: @order.id, product_id: params[:order_product][:product_id])
    if @orderproduct.nil?
      @orderproduct = OrderProduct.new(order_id: @order.id, product_id: params[:order_product][:product_id], quantity: params[:order_product][:quantity])
    end

    @orderproduct.quantity = params[:order_product][:quantity]

    @order.save
    @orderproduct.save

    redirect_to :back
  end

  def index
    @order = Order.find(params[:order_id])
  end

  def show
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    modified_params = order_params
    puts modified_params[:cc_number]
    binding.pry
    modified_params[:cc_number] = modified_params[:cc_number].to_s.split("").last(4).join
    puts modified_params[:cc_number]
    @order.update(modified_params)
    @order.status = "paid"
    @order.save
  end

  def edit
    @current_user = current_user
    @orderproducts = [];

    @order = Order.find_by(buyer_id: @current_user.id, status: "pending") # If the current user already has a pending order, just add to that
    if @order.nil? # This would happen if they haven't added to their cart before viewing it
      @order = Order.create(buyer_id: @current_user.id, status: "pending") # status of the order ("pending", "paid", "complete", "cancelled")
    end

    @order.order_products.each do | orderproduct |
      @orderproducts << orderproduct
    end

  end

  # o.products.exists?
  # o.order_products.exists?
  # o.order_products.size
  # o.order_products.find(1)
  # o.order_products.where(shipped: nil)

  # @book = @author.books.build(published_at: Time.now,
  #                               book_number: "A12345")  # create instead of build will automatically save
  #
  # @books = @author.books.build([
  #   { published_at: Time.now, book_number: "A12346" },
  #   { published_at: Time.now, book_number: "A12347" }
  # ])

  def destroy

    # To Remove everything from the cart
    if params[:order_id]
      # .. Get all the order_products for this order
      orderproducts_to_delete = OrderProduct.where(order_id: params[:order_id])
      # .. if the order is pending
      if Order.find_by(id: params[:order_id]).status == "pending"  # just in case, probably not necessary
        # .. Delete them
        orderproducts_to_delete.each do | orderproduct |
          orderproduct.destroy
        end
      end
    # To just remove one thing from the cart
    elsif params[:id]
      orderproduct = OrderProduct.find(params[:id])
      orderproduct.destroy
    end

    redirect_to(:back)
  end



private

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

   def order_params
     params.require(:order).permit(:cc_number, :cc_expiration, :address, :buyer_id)
   end

end
