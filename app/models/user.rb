class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""
  field :name, type: String
  field :first_name, type: String
  field :last_name, type: String
  field :phone, type: String
  field :location, type: String
  field :image, type: String
  field :nickname, type: String
  validates_presence_of :email
  validates_presence_of :encrypted_password
  
  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String

  has_one :authentication, :dependent => :delete

  def apply_omniauth(user_hash)
    self.name = user_hash[:info][:name]
    self.email = user_hash[:info][:nickname] + '@custom_twitter.com'
    self.nickname = user_hash[:info][:nickname]

    self.first_name = user_hash[:info][:first_name]

    self.last_name = user_hash[:info][:last_name]
    
    self.location = user_hash[:info][:location]

    self.image = user_hash[:info][:image]
    self.phone = user_hash[:info][:phone]
    pass = Devise.friendly_token
    self.password = pass
    self.password_confirmation = pass
    
  end
end
