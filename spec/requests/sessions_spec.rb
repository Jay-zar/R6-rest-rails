require 'swagger_helper'

describe 'sessions API' do
  #Creates swagger for documentaion for login
  path '/users/sign_in' do

    post 'Creates a session' do
      let(:user1) { FactoryBot.create(:user) }
      tags 'sessions'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, required: true, schema: {
        type: :object,
        properties: { user: { properties: {
          email: { type: :string },
          password: { type: :string}
        }}},
        required: [ 'email', 'password' ]
      }

      response '201', 'session jwt token created' do
        let(:user) do
          { user: {
              email: user1.email,
              password: user1.password
          }}
        end
        run_test!
      end

      response '401', 'Unauthorized' do
        let(:user) do
          { user: {
              email: user1.email,
              password: ""
          } }
        end
        run_test!
      end
    end
  end

#Swagger documentation for logout.
  path '/users/sign_out' do

    delete 'Destroy JWT token' do
      let(:user) { FactoryBot.create(:user) }
      let (:auth_header) {"Bearer "+Warden::JWTAuth::UserEncoder.new.call(user, :user,nil)[0]}
      tags 'sessions'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: {}]
      #This includes a valid auth token header
        response '200', 'blacklist token' do
          let(:"Authorization") {auth_header}
          run_test!
        end
        #This does not include anything in the header so it fails
      response '401', 'no token to blacklist' do
        let(:"Authorization") {}
        run_test!
      end
    end
  end
end