class PageHeaderComponent < ApplicationRecord
  has_one :page_component, as: :component, autosave: true
end
