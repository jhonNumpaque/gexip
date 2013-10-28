class Serieproceso < ActiveRecord::Base
  #validaciones
  validates :nombre, :presence => true
  validates :objetivo, :presence => true
  validates :codigo, :presence => true, :uniqueness => true

  has_many :serieprocesos
  has_many :procedimientos

  belongs_to :cargo_ente
  belongs_to :serieproceso
  has_one :cargo, :through => :cargo_ente

  after_save :update_counter_cache
  after_destroy :update_counter_cache
  before_create :set_defaults

  scope :de_la_estructura, lambda { |estructura_id| where(:estructura_id => estructura_id)}

  def tree_state
  	'closed' if self.serieprocesos_count > 0 || self.procedimientos_count > 0
  end

  private
  def update_counter_cache
    if self.serieproceso_id?
      self.serieproceso.serieprocesos_count = Serieproceso.where(serieproceso_id: self.serieproceso_id).count
      self.serieproceso.save
    end
  end

  def set_defaults
    self.serieprocesos_count = 0
    self.procedimientos_count = 0
  end
end
