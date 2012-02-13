class Barrio < Territorio
    #validate
    validates :territorio_id, :presence => true
  
    # asociaciones
    belongs_to :ciudad, :foreign_key => :territorio_id
end
