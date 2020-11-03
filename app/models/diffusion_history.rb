class DiffusionHistory < ApplicationRecord
  before_save :clear_map_histories_on_save, on: :update
  after_save :reset_map_histories, on: :update

  belongs_to :practice
  has_many :diffusion_history_statuses, dependent: :destroy

  attr_accessor :facility_name
  attr_accessor :reset_map_histories_cache

  def clear_map_histories
    cache_key = "map_histories"
    Rails.cache.delete(cache_key)
    DiffusionHistory.map_histories
  end

  def clear_map_histories_on_save
    if self.changed?
      self.reset_map_histories_cache = true
    end
  end

  def reset_map_histories
    clear_map_histories if self.reset_map_histories_cache
  end

  def facility_name
    facilities = JSON.parse(File.read("#{Rails.root}/lib/assets/vamc.json"))
    facility = facilities.find { |f| f['StationNumber'] == facility_id }
    facility['OfficialStationName']
  end

  def self.map_histories
    Rails.cache.fetch('map_histories') do
      DiffusionHistory.all.reject { |dh| !dh.practice.published }
    end
  end
end