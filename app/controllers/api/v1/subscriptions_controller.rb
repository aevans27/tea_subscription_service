class Api::V1::SubscriptionsController < ApplicationController
  def index
    if params[:customer_id].present?
      customer = Customer.find(params[:customer_id])
      if customer
        if customer.subscriptions.count > 0
          customer_subs = []
          customer.subscriptions.each do |subscript|
            s = {
              :title => subscript.title,
              :price => subscript.price,
              :status => subscript.status,
              :frequency => subscript.frequency
            }
            customer_subs << s
          end
          render json: {
            "data": {
              "type": "subscriptions_list",
              "attributes": {
                "subscriptions": customer_subs,
              }
            }
          }, status: 201
        else
          render json: {
            "data": {
              "subcriptions": []
            }
          }, status: 200
        end
      else
        render json: {errors: "Customer doesn't exist"}, status: 404
      end
    else
      render json: {errors: "Empty fields"}, status: 404
    end
  end

  def create
    existing_sub = Subscription.find_by(title: params[:title])
    if existing_sub
      render json: {errors: "Subscription already exists"}, status: 404
    else
      if params[:title].present? && params[:price].present? && params[:status].present? && params[:frequency].present? && params[:customer_id].present?
        customer = Customer.find(params[:customer_id])
        if customer
          new_sub = customer.subscriptions.create(title: params[:title], price: params[:price], status: params[:status], frequency: params[:frequency])
          render json: {
            "data": {
              "type": "subscriptions",
              "id": new_sub.id,
              "attributes": {
                "title": new_sub.title,
                "price": new_sub.price,
                "status": new_sub.status,
                "frequency": new_sub.frequency
              }
            }
          }, status: 201
        else
          render json: {errors: "Customer doesn't exist"}, status: 404
        end
      else
        render json: {errors: "Empty fields"}, status: 404
      end
    end
  end

  def destroy 
    existing_customer = Customer.find_by(id: params[:customer_id])
    existing_sub = existing_customer.subscriptions.find_by(id: params[:id])
    if existing_sub
      existing_sub.delete
      render json: {data: "Subscription deleted"}, status: 200
    else
      render json: {errors: "Subscription doesn't exist"}, status: 404
    end
  end
end