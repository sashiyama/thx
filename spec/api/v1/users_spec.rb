require 'rails_helper'
require 'json_expressions/rspec'

RSpec.describe Users::V1 do
  describe 'GET /v1/users ユーザー一覧' do
    let(:user){
      create(:user,
             email: 'example@example.com',
             name: 'example',
             password: 'ExamplePassword1234',
             password_confirmation: 'ExamplePassword1234')
    }
    it '登録されたユーザーが返る' do
      pattern = {
        users: [
          {
            name: user.name,
            address: user.address,
            verified: user.verified
          }
        ]
      }
      get '/v1/users'
      expect(response.status).to eq 200
      expect(response.body).to match_json_expression(pattern)
    end
  end

  describe 'POST /v1/users ユーザー登録' do
    context 'バリデーション成功の場合' do
      it '保存されたリクエストがレスポンスとして返る' do
        request_body = {
          email: 'example@example.com',
          password: 'ExamplePassword1234',
          password_confirmation: 'ExamplePassword1234'
        }
        pattern = {
          email: 'example@example.com',
          address: String,
          thx_balance: 1000
        }
        post '/v1/users', :params => request_body
        expect(response.status).to eq 201
        expect(response.body).to match_json_expression(pattern)
      end
    end

    context 'すでにメールアドレスが存在する場合' do
      let(:user){
        create(:user,
               email: 'example@example.com',
               password: 'ExamplePassword1234',
               password_confirmation: 'ExamplePassword1234')
      }
      it 'エラーメッセージが返る' do
        request_body = {
          email: user.email,
          password: 'ExamplePassword1234',
          password_confirmation: 'ExamplePassword1234'
        }
        pattern = {
          developerMessage: 'メールアドレスはすでに登録済みです',
          userMessage: 'メールアドレスはすでに登録済みです'
        }
        post '/v1/users', :params => request_body
        expect(response.status).to eq 400
        expect(response.body).to match_json_expression(pattern)
      end
    end
  end
end
