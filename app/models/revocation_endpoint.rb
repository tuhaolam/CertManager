class RevocationEndpoint < ActiveRecord::Base
  belongs_to :public_key
end
