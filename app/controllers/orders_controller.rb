class OrdersController < ApplicationController
  def index
    @orders = Order.all
    render json: @orders
  end

  def create
    @order = Order.new(order_params)
    if @user.save
      render json: { status: :ok, message: 'Success' }
    else
      render json: { json: @order.errors, status: :unprocessable_entity }
    end
  end

  def show
    @order = Order.find(params[:id])
    render json: { data: @order, status: :ok, message: 'Success' }
  end

  def update
    @order = Order.find(params[:id])
    if @order.update(order_params)
      render json: { status: :ok, message: 'Success' }
    else
      render json: { json: @order.error, status: :unprocessable_entity }
    end
  end

  def destroy
    @order = Order.find(params[:id])
    if @order.destroy
      render json: { json: 'Order was successfully deleted.'}
    else
      render json: { json: @order.errors, status: :unprocessable_entity }
    end
  end

  private

  def order_params
    params.require(:order).permit(:id, :Crust, :Flavor, :Size, :Table_No)
  end
end
