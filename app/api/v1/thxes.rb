module Thxes
  class V1 < Grape::API
    # /v1/thx
    resource 'thxes' do
      # GET /v1/users/thxes
      desc '現状のthx情報取得'
      get '/' do
        {
          thx_balance: current_user.thx_balance,
          received_thx: current_user.received_thx
        }
      end

      # GET /v1/users/thxes/transactions
      desc 'thx取引履歴の取得'
      get 'transactions', jbuilder: 'v1/thx/transactions' do
        @thx_transactions = ThxTransaction.where(sender_id: current_user.id).or(ThxTransaction.where(receiver_id: current_user.id)).page(params[:page])
      end

      # POST /v1/users/thxes
      desc 'thxの送信'
      params do
        requires :address, type: String, desc: 'ユーザーに紐づくハッシュアドレス'
        requires :thx, type: Integer, desc: '送信するthx'
        optional :comment, type: String, desc: 'コメント'
      end
      post '/', jbuilder: 'v1/thx/transaction' do
        st_params = strong_params(params).permit(:address, :thx, :comment)
        receiver = User.find_by!(address: st_params[:address])
        ApplicationRecord.transaction do
          @thx_transaction = ThxTransaction.new(thx_hash: SecureRandom.hex,
                                               sender: current_user,
                                               receiver: receiver, thx: st_params[:thx],
                                               comment: st_params[:comment])
          current_user.update!(thx_balance: (current_user.thx_balance - st_params[:thx]))
          receiver.update!(received_thx: (receiver.received_thx + st_params[:thx]))
          @thx_transaction.save!
          send_time_line(@thx_transaction)
        end
      end

      # GET /v1/users/thxes/search?hash=
      desc 'ハッシュに紐づく自分の取引履歴を取得'
      params do
        requires :hash, type: String, desc: 'ThxTransactionに紐づくハッシュアドレス'
      end
      get 'search', jbuilder: 'v1/thx/transaction' do
        @thx_transaction = current_user.receivers.where(thx_hash: params[:hash])
                             .or(current_user.senders.where(thx_hash: params[:hash])).first
        not_found_error if @thx_transaction.blank?
      end
    end
  end
end