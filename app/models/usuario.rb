class Usuario < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable  

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :nombres, :apellidos, :documento, :ente_id, :rol_id, :login

  # validaciones
  validates :login, :presence => true
  validates :nombres, :presence => true
  validates :apellidos, :presence => true
  validates :documento, :presence => true
  #validates :documento, :presence => true
  
  # asociaciones
  belongs_to :rol  
  
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    where(conditions).where(["lower(login) = :value OR lower(email) = :value", { :value => login.strip.downcase }]).first
  end
end
