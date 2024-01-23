require 'rails_helper'

  describe "customer endpoint" do
    it "create a customer" do
      params = {:first_name => "testing", :last_name => "tester", :email => "email@emails.com", :address => "123 sic dr"}
      post "/api/v1/customers", params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      expect(response).to be_successful
      response_body = JSON.parse(response.body, symbolize_names: true)[:data]
      
      expect(response_body[:attributes]).to have_key(:first_name)
      expect(response_body[:attributes][:first_name]).to eq("testing")
      expect(response_body[:attributes]).to have_key(:last_name)
      expect(response_body[:attributes][:last_name]).to eq("tester")
      expect(response_body[:attributes]).to have_key(:email)
      expect(response_body[:attributes][:email]).to eq("email@emails.com")
      expect(response_body[:attributes]).to have_key(:address)
      expect(response_body[:attributes][:address]).to eq("123 sic dr")
      expect(response_body).to have_key(:type)
      expect(response_body[:type]).to eq("customers")
      expect(response_body).to have_key(:id)
      expect(response_body[:id]).to be_an(Integer)
    end

    it "try to create customer that exists" do
      params = {:first_name => "testing", :last_name => "tester", :email => "email@emails.com", :address => "123 sic dr"}
      post "/api/v1/customers", params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      expect(response).to be_successful

      params = {:first_name => "testing", :last_name => "tester", :email => "email@emails.com", :address => "123 sic dr"}
      post "/api/v1/customers", params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      response_body = JSON.parse(response.body, symbolize_names: true)
      expect(response.status).to eq(404)
      expect(response_body).to have_key(:errors)
      expect(response_body[:errors]).to eq("Customer already exists")
    end

    # it "passwords don't match" do 
    #   params = {:email => "person@woohoo.com", :password => "abc123", :password_confirmation => "abc"}
    #   post "/api/v0/users", params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    #   response_body = JSON.parse(response.body, symbolize_names: true)
    #   expect(response.status).to eq(404)
    #   expect(response_body).to have_key(:errors)
    #   expect(response_body[:errors]).to eq("Passwords don't match")
    # end

    # it "empty entry" do 
    #   params = {:email => "", :password => "abc123", :password_confirmation => "abc"}
    #   post "/api/v0/users", params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    #   response_body = JSON.parse(response.body, symbolize_names: true)
    #   expect(response.status).to eq(404)
    #   expect(response_body).to have_key(:errors)
    #   expect(response_body[:errors]).to eq("Empty fields")
    # end
  end