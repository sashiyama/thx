module Root
  class V1 < Grape::API
    # ex) http://api.localhost.local:3000/v1
    version 'v1', :using => :path
    namespace do
      mount Users::V1
    end
  end
end
