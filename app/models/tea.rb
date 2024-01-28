class Tea < ApplicationRecord
  has_many :subscription_teas
  has_many :subscriptions, through: :subscription_teas
  validates :title, presence: true, uniqueness: true
  validates :description, presence: true
  validates :temperature, presence: true
  validates :brew_time, presence: true
end