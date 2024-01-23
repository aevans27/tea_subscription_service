class Api::V1::CustomersController < ApplicationController
  def create
    existing_customer = Customer.find_by(email: params[:email])
    if existing_customer
      render json: {errors: "Customer already exists"}, status: 404
    else
      if params[:first_name].present? && params[:last_name].present? && params[:email].present? && params[:address].present?
          new_customer = Customer.create(first_name: params[:first_name], last_name: params[:last_name], email: params[:email], address: params[:address])
          render json: {
            "data": {
              "type": "customers",
              "id": new_customer.id,
              "attributes": {
                "first_name": new_customer.first_name,
                "last_name": new_customer.last_name,
                "email": new_customer.email,
                "address": new_customer.address
              }
            }
          }, status: 201
      else
        render json: {errors: "Empty fields"}, status: 404
      end
    end
  end
end