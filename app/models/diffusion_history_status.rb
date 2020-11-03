class DiffusionHistoryStatus < ApplicationRecord
  belongs_to :diffusion_history

  before_save :clear_map_history_statuses_on_save, on: :update
  after_save :reset_map_history_statuses, on: :update

  attr_accessor :facility_name
  attr_accessor :reset_map_history_statuses_cache

  def clear_map_history_statuses
    cache_key = "map_history_statuses"
    Rails.cache.delete(cache_key)
    DiffusionHistory.map_histories
  end

  def clear_map_history_statuses_on_save
    if self.changed?
      self.reset_map_history_statuses_cache = true
    end
  end

  def reset_map_history_statuses_cache
    clear_map_histories if self.reset_map_histories_cache
  end

  def self.map_history_statuses
    Rails.cache.fetch('map_history_statuses') do
      DiffusionHistoryStatus.all.reject { |dh| !dh.diffusion_history.practice.published }
    end
  end

  def self.map_statuses_by_history(dh)
    # debugger
    Rails.cache.fetch("history_#{dh.id}_status") do
      DiffusionHistoryStatus.order(id: :desc).where(diffusion_history_id: dh.id)
    end
  end
end
