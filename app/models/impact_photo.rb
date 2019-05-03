class ImpactPhoto < ApplicationRecord
  acts_as_list
  has_attached_file :attachment, styles: { thumb: '1280x720#' }
  crop_attached_file :attachment, aspect: '16:9'
  do_not_validate_attachment_file_type :attachment
  belongs_to :practice
end