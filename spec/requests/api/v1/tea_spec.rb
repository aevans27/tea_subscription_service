require 'rails_helper'

  describe "tea endpoint" do
    it "create a tea" do
      params = {:title => "test_tea", :description => "A tea", :temperature => 99.0, :brew_time => 10}
      post "/api/v1/teas", params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      expect(response).to be_successful
      response_body = JSON.parse(response.body, symbolize_names: true)[:data]
      
      expect(response_body[:attributes]).to have_key(:title)
      expect(response_body[:attributes][:title]).to eq("test_tea")
      expect(response_body[:attributes]).to have_key(:description)
      expect(response_body[:attributes][:description]).to eq("A tea")
      expect(response_body[:attributes]).to have_key(:temperature)
      expect(response_body[:attributes][:temperature]).to eq(99.0)
      expect(response_body[:attributes]).to have_key(:brew_time)
      expect(response_body[:attributes][:brew_time]).to eq(10)
      expect(response_body).to have_key(:type)
      expect(response_body[:type]).to eq("teas")
      expect(response_body).to have_key(:id)
      expect(response_body[:id]).to be_an(Integer)
    end

    it "try to create customer that exists" do
      params = {:title => "test_tea", :description => "A tea", :temperature => 99.0, :brew_time => 10}
      post "/api/v1/teas", params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      expect(response).to be_successful

      params = {:title => "test_tea", :description => "A tea", :temperature => 99.0, :brew_time => 10}
      post "/api/v1/teas", params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      response_body = JSON.parse(response.body, symbolize_names: true)
      expect(response.status).to eq(404)
      expect(response_body).to have_key(:errors)
      expect(response_body[:errors]).to eq("Tea already exists")
    end

    it "try to create customer that is missing a field" do
      params = {:description => "A tea", :temperature => 99.0, :brew_time => 10}
      post "/api/v1/teas", params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      response_body = JSON.parse(response.body, symbolize_names: true)
      expect(response.status).to eq(404)
      expect(response_body).to have_key(:errors)
      expect(response_body[:errors]).to eq("Empty fields")
    end

    it "add teas to subscription" do 
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

      params = {:title => "test_tea1", :description => "A tea", :temperature => 99.0, :brew_time => 10}
      post "/api/v1/teas", params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      expect(response).to be_successful
      response_body = JSON.parse(response.body, symbolize_names: true)[:data]
      tea1_id = response_body[:id]

      params = {:title => "test_tea2", :description => "A tea", :temperature => 99.0, :brew_time => 10}
      post "/api/v1/teas", params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      expect(response).to be_successful
      response_body = JSON.parse(response.body, symbolize_names: true)[:data]
      tea2_id = response_body[:id]

      params = {:tea_id => tea1_id, :sub_id => sub_id}
      patch "/api/v1/subscription_teas", params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      expect(response).to be_successful
      response_body = JSON.parse(response.body, symbolize_names: true)[:data]
      
      expect(response_body[:attributes]).to have_key(:tea_id)
      expect(response_body[:attributes][:tea_id]).to be_an(Integer)
      expect(response_body[:attributes]).to have_key(:subscription_id)
      expect(response_body[:attributes][:subscription_id]).to be_an(Integer)
      expect(response_body[:attributes]).to have_key(:active)
      expect(response_body[:attributes][:active]).to eq(true)
      expect(response_body).to have_key(:type)
      expect(response_body[:type]).to eq("subscription_teas")
      expect(response_body).to have_key(:id)
      expect(response_body[:id]).to be_an(Integer)

      params = {:tea_id => tea2_id, :sub_id => sub_id}
      patch "/api/v1/subscription_teas", params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      expect(response).to be_successful

      params = {:tea_id => tea1_id, :sub_id => sub_id}
      patch "/api/v1/subscription_teas", params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      response_body = JSON.parse(response.body, symbolize_names: true)
      expect(response.status).to eq(404)
      expect(response_body).to have_key(:errors)
      expect(response_body[:errors]).to eq("Tea already part of subscription")

      params = {:sub_id => sub_id}
      patch "/api/v1/subscription_teas", params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      response_body = JSON.parse(response.body, symbolize_names: true)
      expect(response.status).to eq(404)
      expect(response_body).to have_key(:errors)
      expect(response_body[:errors]).to eq("Empty fields")
    end
  end