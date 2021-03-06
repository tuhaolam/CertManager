class Authorization < ActiveRecord::Base
  belongs_to :o_auth_provider
  validates :type, inclusion: { in: %w(user group) }

  scope :for_oauth_attempt, lambda { |user_id, group_ids|
    where("(\"authorization_type\" = 'user' AND \"identifier\" = ?) OR (\"authorization_type\" = 'group' AND \"identifier\" IN (?))",
          user_id.to_s, group_ids.map(&:to_s))
      .order(authorization_type: :desc)
  }
end
