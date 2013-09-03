class VersionAprobada < ActiveRecord::Base
  attr_accessible :item_id, :tipo_item, :version_id

	belongs_to :version
end
