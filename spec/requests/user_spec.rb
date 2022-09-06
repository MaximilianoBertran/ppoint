RSpec.describe UsersController, type: :request do
  describe 'POST /create' do

    context 'when valid' do
      let (:user_attrs) { FactoryBot.attributes_for(:user) }
      before do        
        post '/users', params: { name: user_attrs[:name], email: user_attrs[:email], password: user_attrs[:password] }
      end
      
      it 'should be json response' do
        expect(response.content_type).to include 'application/json'
      end

      it 'should be user' do
        expect(json_body['user']['id']).to be_a_kind_of(Integer)
        expect(json_body['user']['name']).to include user_attrs[:name]
        expect(json_body['user']['email']).to include user_attrs[:email]
        expect(json_body['token']).to be_a_kind_of(String)
      end

    end
    
    context 'when params is empty' do
      before do        
        post '/users'
      end

      it 'should be json response with specific invalid parameters' do
        expect(response.content_type).to include 'application/json'
        expect(json_body['error'])
      end

    end
  end

  describe 'POST /login' do

    let (:user_attrs) { FactoryBot.attributes_for(:user) }
    before do        
      post '/users', params: { name: user_attrs[:name], email: user_attrs[:email], password: user_attrs[:password] }
    end
    
    context 'with valid credentials' do
      it 'should be json response' do
        post '/login', params: { email: user_attrs[:email], password: user_attrs[:password] }
        expect(response.content_type).to include 'application/json'    
        expect(json_body['name']).to include user_attrs[:name]
        expect(json_body['token']).to be_a_kind_of(String)
        expect(json_body['expiration'].to_datetime).to be_a_kind_of(DateTime)
      end
    end

    context 'with valid credentials' do
      it 'should be json response' do
        post '/login', params: { email: user_attrs[:email], password: '1111' }
        expect(response.content_type).to include 'application/json'        
        expect(json_body['error']).to include 'Invalid email or password'
      end
    end
  end
end
