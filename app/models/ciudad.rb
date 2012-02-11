class Ciudad < Territorio
    #validate
    validates :territorio_id, :presence => true
  
    # asociaciones
    belongs_to :pais, :foreign_key => :territorio_id
end
