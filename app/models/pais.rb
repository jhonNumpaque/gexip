class Pais < Territorio
    # asociaciones
  has_many :ciudad, :dependent => :restrict, :foreign_key => :territorio_id
end
