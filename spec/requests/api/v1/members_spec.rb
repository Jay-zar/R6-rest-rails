require 'swagger_helper'

RSpec.describe 'api/v1/members', type: :request do
  let(:user1) { FactoryBot.create(:user) }
  let (:token){Warden::JWTAuth::UserEncoder.new.call(user1,:user,nil)}
  let(:Authorization){ "Bearer "+ token[0]}
  let!(:members) { FactoryBot.create_list(:member, 10) }
  let(:member_id) { members.first.id }

  path '/api/v1/members' do

    get('list members') do
      tags 'Members'
      produces 'application/json'
      security [Bearer: {}]
      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    post('create member') do
      tags 'Members'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: {}]
      parameter name: :member, in: :body, required: true, schema: {
        type: :object,
        required: %i[first_name last_name],
        properties: {
          first_name: { type: :string },
          last_name: { type: :string }
        }
      }

      response(201, 'successful') do
        let(:member) { { first_name: "jqpublic23", last_name: "mypasswd"}}

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/api/v1/members/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show member') do
      tags 'Members'
      security [Bearer: {}]
      response(200, 'successful') do
        let(:id) { member_id }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    patch('update member') do
      tags 'Members'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: {}]
      parameter name: :member, in: :body, schema: {
        type: :object,
        properties: {
          first_name: { type: :string },
          last_name: { type: :string }
        }
      }
      response(200, 'successful') do
        let(:id) { member_id }
        let(:member) {{first_name: 'fred'}}
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    put('update member') do
      tags 'Members'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: {}]
      parameter name: :member, in: :body, schema: {
        type: :object,
        properties: {
          first_name: { type: :string },
          last_name: { type: :string }
        }
      }
      response(200, 'successful') do
        let(:id) { member_id }
        let(:member) {{first_name: 'fred'}}

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    delete('delete member') do
      tags 'Members'
      security [Bearer: {}]
      response(200, 'successful') do
        let(:id) { member_id }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end
end