#require 'rails_helper'

RSpec.describe 'PurchasesController', type: :request do

  let (:user_attrs) { FactoryBot.attributes_for(:user) }
  before do        
    post '/users', params: { name: user_attrs[:name], email: user_attrs[:email], password: user_attrs[:password] }
  end
  token = UsersToken.last.token
  headers = { 'Authorization' => "Bearer #{token}" }

  FactoryBot.create_list(:category, 30)  if Product.count < 100

  describe 'GET top sell' do
    before do        
      get '/purchases/top_sell', headers: headers
    end

    it 'top sell by units rank' do
      expect(json_body).to be_a_kind_of(Hash)
    end
  end

  describe 'GET top amount' do
    before do        
      get '/purchases/top_amount', headers: headers
    end

    it 'top sell by amount rank' do
      expect(json_body).to be_a_kind_of(Hash)
    end
  end

  describe 'GET purchases' do
    context 'purchases paginate' do
      before do        
        get '/purchases', headers: headers, params: {page: 1, per_page: 10}
      end

      it 'get first page of purchases' do
        expect(json_body.size).to eq(10)
        expect(json_body).to be_a_kind_of(Array)
      end
    end
  end

  describe 'GET graphic data' do
    before do
      granularity = "day"
      get "/purchases/graphic/#{granularity}", headers: headers
    end

    it 'sell detail by granularity' do
      expect(json_body).to be_a_kind_of(Array)
    end
  end
end
