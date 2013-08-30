class Usuario < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable  

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :rol_id, :login, :funcionario_id

  # validaciones
  validates :login, :presence => true, :uniqueness => true
  validates :funcionario_id, :presence => true, :uniqueness => true
  validates :rol_id, :presence => true
  validates :email, :presence => true, :uniqueness => true
  
  validates_uniqueness_of :login
  validates_uniqueness_of :email
  
  # asociaciones
  belongs_to :rol, :foreign_key => :rol_id
  belongs_to :funcionario, :foreign_key => :funcionario_id
  
  has_many :expedientes, :dependent => :restrict
  #has_many :tarea_expedientes, :dependent => :restrict
    
  
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
    "#{self.funcionario.nombres} #{self.funcionario.apellidos}".strip
  end
  #Concatena apellido y nombre
  def apellido_nombre
    "#{self.funcionario.apellidos}, #{self.funcionario.nombres}".strip
  end
end
