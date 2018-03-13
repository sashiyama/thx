module Users
  class V1 < Grape::API
    # /v1/users
    resource 'users' do
      # GET /v1/users
      desc 'ユーザー一覧取得'
      get '/', jbuilder:'v1/users/index' do
        # TBD
      end
    end
  end
end
