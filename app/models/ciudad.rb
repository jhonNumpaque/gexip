class Ciudad < Territorio
    # asociaciones
    belongs_to :pais, :foreign_key => :territorio_id
end
