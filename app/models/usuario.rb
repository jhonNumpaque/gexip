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
  belongs_to :rol, :foreign_key => :rol_id
  belongs_to :ente, :foreign_key => :ente_id
  has_many :procedimientos
  
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    where(conditions).where(["lower(login) = :value OR lower(email) = :value", { :value => login.strip.downcase }]).first
  end
  
  # CONSTANTE
  TIPO_BUSQUEDA = %w{TODOS USUARIO NOMBRE APELLIDO DOCUMENTO}
  
  #Concatena nombre y apellido
  def nombre_completo
    "#{self.nombres} #{self.apellidos}".strip
  end
  #Concatena apellido y nombre
  def apellido_nombre
    "#{self.apellidos}, #{self.nombres}".strip
  end
end
