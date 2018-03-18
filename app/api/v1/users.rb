module Users
  class V1 < Grape::API
    # /v1/users
    resource 'users' do
      # GET /v1/users
      desc 'ユーザー一覧取得'
      get '/', jbuilder:'v1/users/index' do
        user_signed_in?
        @users = enable_user.page(params[:page])
      end

      # POST /v1/users
      desc 'ユーザー登録'
      params do
        requires :email, type: String, desc: 'メールアドレス'
        optional :name, type: String, desc: '名前'
        requires :password, type: String, desc: 'パスワード'
        requires :password_confirmation, type: String, desc: 'パスワード確認用'
      end
      post '/', jbuilder: 'v1/users/me' do
        st_params = strong_params(params).permit(:email, :password, :password_confirmation, :name)
        @user = User.new(email: st_params[:email],
                 password: st_params[:password],
                 password_confirmation: st_params[:password_confirmation],
                 name: st_params[:name].presence,
                 address: SecureRandom.hex,
                 thx_balance: User::INIT_THX)
        @user.save!
      end

      # POST /v1/users/sign_in
      desc 'ログイン'
      params do
        requires :email, type: String, desc: 'メールアドレス'
        requires :password, type: String, desc: 'パスワード'
        optional :auto_login, type: Boolean, desc: '自動的にログイン'
      end
      post 'sign_in' do
        st_params = strong_params(params).permit(:email, :password, :auto_login)
        user = enable_user.find_by(email: st_params[:email])
        if user && user.authenticate(st_params[:password])
          AccessToken.generate_token(user, st_params[:auto_login])
        else
          error_format('Invalid Email or Invalid Password', 'メールアドレスまたはパスワードが間違っています。', 400)
        end
      end

      # patch /v1/users/refresh_token
      desc 'トークンリフレッシュ'
      params do
        requires :refresh_token, type: String
      end
      patch '/refresh_token' do
        st_params = strong_params(params).permit(:refresh_token)
        access_token = AccessToken.refresh_token(st_params[:refresh_token])
        if access_token.present?
          {
            access_token: access_token.token,
            expires_at: access_token.expires_at
          }
        else
          error_format('Invalid Refresh Token', '有効なリフレッシュトークンではありません。', 400)
        end
      end

      # GET /v1/users/search?q={検索キーワード}
      desc 'ユーザー検索'
      params do
        requires :q, type: String, desc: '検索クエリ'
      end
      get 'search', jbuilder:'v1/users/index' do
        user_signed_in?
        st_params = strong_params(params).permit(:q)
        @users = if st_params[:q].blank?
                   nil
                 else
                   enable_user.where('email LIKE(?) OR name LIKE(?)', "%#{st_params[:q]}%", "%#{st_params[:q]}%").page(params[:page])
                 end
      end

      desc '自分の情報を取得'
      get 'me', jbuilder: 'v1/users/me' do
        @user = current_user
      end

      mount Thxes::V1
    end
  end
end
