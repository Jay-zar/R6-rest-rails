require 'swagger_helper'

RSpec.describe 'api/v1/facts', type: :request do
  # Initialize the test data
  let(:user1) { FactoryBot.create(:user) }
  let (:token){Warden::JWTAuth::UserEncoder.new.call(user1,:user,nil)}
  let(:Authorization){ "Bearer "+ token[0]}

  let!(:member) { FactoryBot.create(:member) }
  let!(:facts) { FactoryBot.create_list(:fact, 20, member_id: member.id) }
  let(:member_id) { member.id }
  let(:fact_id) { facts.first.id }

  path '/api/v1/members/{member_id}/facts' do
    parameter name: 'member_id', in: :path, type: :string, description: 'member_id'

    get('list facts') do
      tags 'Facts'
      security [Bearer: {}]
      response(200, 'successful') do

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    post('create fact') do
      tags 'Facts'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: {}]
      parameter name: :fact, in: :body, required: true, schema: {
        type: :object,
        required: %i[fact_text likes],
        properties: {
          fact_text: {type: :string},
          likes: {type: :integer}
        }
      }
      response(201, 'successful') do
        let(:fact) { { fact_text: "This is a fact.", likes: 15} }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/api/v1/members/{member_id}/facts/{fact_id}' do
    parameter name: 'member_id', in: :path, type: :string, description: 'member_id'
    parameter name: 'fact_id', in: :path, type: :string, description: 'id'

    get('show fact') do
      tags 'Facts'
      security [Bearer: {}]
      response(200, 'successful') do

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    patch('update fact') do
      tags 'Facts'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: {}]
      parameter name: :fact, in: :body, required: true, schema: {
        type: :object,
        properties: {
          fact_text: {type: :string},
          likes: {type: :integer}
        }
      }
      response(200, 'successful') do
        let(:fact) { {fact_text: "This is another fact."}}

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    put('update fact') do
      tags 'Facts'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: {}]
          parameter name: :fact, in: :body, required: true, schema: {
        type: :object,
        properties: {
          fact_text: {type: :string},
          likes: {type: :integer}
        }
      }
      response(200, 'successful') do
        let(:fact) {{ fact_text: "This is another fact." }}

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    delete('delete fact') do
      tags 'Facts'
      security [Bearer: {}]
      response(200, 'successful') do

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end
end