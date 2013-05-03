class Adjunto < ActiveRecord::Base
  belongs_to :adjuntable, :polymorphic => true

  mount_uploader :data, AdjuntoUploader

  before_save :update_asset_attributes
  
  private
  
  def update_asset_attributes
    if data.present? && data_changed?
      self.content_type = data.file.content_type
      self.file_size = data.file.size
    end
  end
end
