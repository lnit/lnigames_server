class Project < ApplicationRecord
  before_create do
    self.secret = SecureRandom.urlsafe_base64
  end
end
