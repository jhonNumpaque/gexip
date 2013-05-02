class Ciudad < Territorio
    #validate
    validates :territorio_id, :presence => true
  
    # asociaciones
    belongs_to :pais, :foreign_key => :territorio_id
    has_many :entes, :dependent => :restrict, :foreign_key => :territorio_id
    has_many :personas_fisicas, :dependent => :restrict, :foreign_key => :territorio_id
end
