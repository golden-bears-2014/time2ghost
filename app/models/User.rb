class User < ActiveRecord::Base
  has_secure_password
  attr_accessible :username, :walk_speed, :phone_number, :email, :password
  validates :username, presence: :true, uniqueness: true
  validates :phone_number, presence: true
  validates :email, presence: true
  validates :password, length: { in: 6..50 }
  has_many :trips

  def format_phone_number
    phone = self.phone_number
    "(#{phone[0, 3]}) #{phone[3, 3]}-#{phone[6, 4]}"
  end

end