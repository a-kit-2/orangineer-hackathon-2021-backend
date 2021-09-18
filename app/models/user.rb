class User < ApplicationRecord
  has_many :connections, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :joinnings, dependent: :destroy
  has_many :events, dependent: :destroy, through: :joinnings

  def self.from_token_payload(payload)
    find_by(sub: payload['sub']) || create!(sub: payload['sub'])
  end
end
