class Adjunto < ActiveRecord::Base
  belongs_to :adjuntable, :polymorphic => true
  has_many :cargos_estructuras_adjuntos, :dependent => :destroy

  mount_uploader :data, AdjuntoUploader

  before_save :update_asset_attributes

  accepts_nested_attributes_for :cargos_estructuras_adjuntos, :reject_if => lambda { |a| a[:cargo_estructura_id].blank? }, :allow_destroy => true
  
  private
  
  def update_asset_attributes
    if data.present? && data_changed?
      self.content_type = data.file.content_type
      self.file_size = data.file.size
    end
  end
end
