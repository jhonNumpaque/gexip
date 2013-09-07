class AdjuntoTareaExpediente < ActiveRecord::Base
  mount_uploader :data, AdjuntoUploader

  belongs_to :adjunto, :foreign_key => :adjunto_id
  belongs_to :tarea_expediente, :foreign_key => :tarea_expediente_id

  before_save :update_data_attributes
  after_commit :remove_data!, :on => :destroy

  private

  def update_data_attributes
    if data.present? && data_changed?
      self.content_type = data.file.content_type
      self.file_size = data.file.size
    end
  end
end