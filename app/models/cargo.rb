class Cargo < ActiveRecord::Base
	validates :nombre, :presence => true
    validates :nombre, :uniqueness => true
  
	has_many :ente, :dependent => :restrict
end
