class Api::V1::TeasController < ApplicationController
  def create
    existing_tea = Tea.find_by(title: params[:title])
    if existing_tea
      render json: {errors: "Tea already exists"}, status: 404
    else
      if params[:title].present? && params[:description].present? && params[:temperature].present? && params[:brew_time].present?
          new_tea = Tea.create(title: params[:title], description: params[:description], temperature: params[:temperature], brew_time: params[:brew_time])
          render json: {
            "data": {
              "type": "teas",
              "id": new_tea.id,
              "attributes": {
                "title": new_tea.title,
                "description": new_tea.description,
                "temperature": new_tea.temperature,
                "brew_time": new_tea.brew_time
              }
            }
          }, status: 201
      else
        render json: {errors: "Empty fields"}, status: 404
      end
    end
  end

  def sub_change
    existing_sub_tea = SubscriptionTea.find_by(tea_id: params[:tea_id], subscription_id: params[:sub_id])
    if existing_sub_tea
      render json: {errors: "Tea already part of subscription"}, status: 404
    else
      if params[:tea_id].present? && params[:sub_id].present?
          new_sub_tea = SubscriptionTea.create(tea_id: params[:tea_id], subscription_id: params[:sub_id])
          render json: {
            "data": {
              "type": "subscription_teas",
              "id": new_sub_tea.id,
              "attributes": {
                "tea_id": new_sub_tea.tea_id,
                "subscription_id": new_sub_tea.subscription_id,
                "active": new_sub_tea.active
              }
            }
          }, status: 201
      else
        render json: {errors: "Empty fields"}, status: 404
      end
    end
  end
end