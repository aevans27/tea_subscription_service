require 'rails_helper'

  describe "subscription endpoint" do
    it "create a sub" do
      params = {:first_name => "testing", :last_name => "testy", :email => "email@emails.com", :address => "123 sic dr"}
      post "/api/v1/customers", params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      expect(response).to be_successful
      response_body = JSON.parse(response.body, symbolize_names: true)[:data]
      customer_id = response_body[:id]

      params = {:title => "tester", :price => 123.45, :status => "active", :frequency => 1, :customer_id => customer_id}
      post "/api/v1/subscriptions", params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      expect(response).to be_successful
      response_body = JSON.parse(response.body, symbolize_names: true)[:data]
      
      expect(response_body[:attributes]).to have_key(:title)
      expect(response_body[:attributes][:title]).to eq("tester")
      expect(response_body[:attributes]).to have_key(:price)
      expect(response_body[:attributes][:price]).to eq(123.45)
      expect(response_body[:attributes]).to have_key(:status)
      expect(response_body[:attributes][:status]).to eq("active")
      expect(response_body[:attributes]).to have_key(:frequency)
      expect(response_body[:attributes][:frequency]).to eq(1)
      expect(response_body).to have_key(:type)
      expect(response_body[:type]).to eq("subscriptions")
      expect(response_body).to have_key(:id)
      expect(response_body[:id]).to be_an(Integer)
    end

    it "try to create sub that exists" do
      params = {:first_name => "testing", :last_name => "testy", :email => "email@emails.com", :address => "123 sic dr"}
      post "/api/v1/customers", params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      expect(response).to be_successful
      response_body = JSON.parse(response.body, symbolize_names: true)[:data]
      customer_id = response_body[:id]

      params = {:title => "tester", :price => 123.45, :status => "active", :frequency => 1, :customer_id => customer_id}
      post "/api/v1/subscriptions", params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      expect(response).to be_successful
      response_body = JSON.parse(response.body, symbolize_names: true)[:data]

      params = {:title => "tester", :price => 123.45, :status => "active", :frequency => 1, :customer_id => customer_id}
      post "/api/v1/subscriptions", params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      response_body = JSON.parse(response.body, symbolize_names: true)
      expect(response.status).to eq(404)
      expect(response_body).to have_key(:errors)
      expect(response_body[:errors]).to eq("Subscription already exists")
    end

    it "find all subscriptions" do 
      params = {:first_name => "testing", :last_name => "testy", :email => "email@emails.com", :address => "123 sic dr"}
      post "/api/v1/customers", params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      expect(response).to be_successful
      response_body = JSON.parse(response.body, symbolize_names: true)[:data]
      customer_id = response_body[:id]

      params = {:title => "tester", :price => 123.45, :status => "active", :frequency => 1, :customer_id => customer_id}
      post "/api/v1/subscriptions", params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      expect(response).to be_successful

      params = {:title => "tester2", :price => 123.45, :status => "active", :frequency => 1, :customer_id => customer_id}
      post "/api/v1/subscriptions", params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      expect(response).to be_successful
      
      get "/api/v1/customers/#{customer_id}/subscriptions"
      expect(response).to be_successful
      response_body = JSON.parse(response.body, symbolize_names: true)[:data]
      
      expect(response_body[:attributes]).to have_key(:subscriptions)
      expect(response_body[:attributes][:subscriptions].count).to eq(2)
    end

    it "delete subscription" do 
      params = {:first_name => "testing", :last_name => "testy", :email => "email@emails.com", :address => "123 sic dr"}
      post "/api/v1/customers", params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      expect(response).to be_successful
      response_body = JSON.parse(response.body, symbolize_names: true)[:data]
      customer_id = response_body[:id]

      params = {:title => "tester", :price => 123.45, :status => "active", :frequency => 1, :customer_id => customer_id}
      post "/api/v1/subscriptions", params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      expect(response).to be_successful
      response_body = JSON.parse(response.body, symbolize_names: true)[:data]
      sub_id = response_body[:id]

      delete "/api/v1/customers/#{customer_id}/subscriptions/#{sub_id}"
      expect(response).to be_successful
      response_body = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(response_body).to eq("Subscription deleted")
    end
  end