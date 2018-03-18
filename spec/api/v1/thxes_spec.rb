require 'rails_helper'
require 'json_expressions/rspec'

RSpec.describe Thxes::V1 do
  describe 'GET /v1/users/thxes 現状のthx情報取得' do
    let(:signed_in_user){ create(:user, :sign_in) }
    it '現状の残高と受け取ったThxの全量を返す' do
      pattern = {
        thx_balance: signed_in_user.thx_balance,
        received_thx: signed_in_user.received_thx
      }
      get '/v1/users/thxes', :headers => {'Authorization' => "Bearer #{signed_in_user.access_token.token}"}
      expect(response.status).to eq 200
      expect(response.body).to match_json_expression(pattern)
    end
  end

  describe 'GET /v1/users/thxes/transactions thx取引履歴の取得' do
    let(:signed_in_user){ create(:user, :sign_in) }
    let(:user){ create(:user) }
    let(:thx_transaction){ create(:thx_transaction, sender: signed_in_user, receiver: user) }
    it '取引履歴を返す' do
      pattern = {
        thx_transactions: [
          {
            thx_hash: thx_transaction.thx_hash,
            sender: {
              name: signed_in_user.name,
              address: signed_in_user.address,
              verified: signed_in_user.verified
            },
            receiver: {
              name: user.name,
              address: user.address,
              verified: user.verified
            },
            thx: thx_transaction.thx,
            comment: thx_transaction.comment,
            created_at: String
          }
        ]
      }
      get '/v1/users/thxes/transactions', :headers => {'Authorization' => "Bearer #{signed_in_user.access_token.token}"}
      expect(response.status).to eq 200
      expect(response.body).to match_json_expression(pattern)
    end
  end

  describe 'POST /v1/users/thxes thxの送信' do
    let(:signed_in_user){ create(:user, :sign_in) }
    let(:user){ create(:user) }
    let(:thx){ rand(1000) }
    context '残高内の場合' do
      it '取引情報が返る' do
        request_body = {
          address: user.address,
          thx: thx
        }
        pattern = {
          thx_hash: String,
          sender: {
            name: signed_in_user.name,
            address: signed_in_user.address,
            verified: signed_in_user.verified
          },
          receiver: {
            name: user.name,
            address: user.address,
            verified: user.verified
          },
          thx: thx,
          comment: nil,
          created_at: String
        }
        post '/v1/users/thxes', :params => request_body, :headers => {'Authorization' => "Bearer #{signed_in_user.access_token.token}"}
        expect(response.status).to eq 201
        expect(response.body).to match_json_expression(pattern)
        expect(User.find(signed_in_user.id).thx_balance).to eq((User::INIT_THX - thx))
        expect(User.find(user.id).received_thx).to eq thx
      end
    end

    context '残高が足りない場合' do
      it 'エラーメッセージが返る' do
        request_body = {
          address: user.address,
          thx: 1001
        }
        pattern = {
          developerMessage: '残高が0を下回っています',
          userMessage: '残高が0を下回っています'
        }
        post '/v1/users/thxes', :params => request_body, :headers => {'Authorization' => "Bearer #{signed_in_user.access_token.token}"}
        expect(response.status).to eq 400
        expect(response.body).to match_json_expression(pattern)
      end
    end

    context '送信先アドレスが間違っている場合' do
      it 'エラーメッセージが返る' do
        request_body = {
          address: 'fake-address',
          thx: thx
        }
        pattern = {
          developerMessage: 'Not Found',
          userMessage: '指定されたものは見つかりません。'
        }
        post '/v1/users/thxes', :params => request_body, :headers => {'Authorization' => "Bearer #{signed_in_user.access_token.token}"}
        expect(response.status).to eq 404
        expect(response.body).to match_json_expression(pattern)
      end
    end
  end
end
