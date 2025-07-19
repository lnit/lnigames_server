class Project < ApplicationRecord
  has_many :ranking_boards, dependent: :destroy

  before_create do
    self.secret = SecureRandom.urlsafe_base64
  end
end
