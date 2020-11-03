class DiffusionHistoryStatus < ApplicationRecord
  before_save :clear_map_history_statuses_on_save, on: [:update, :create, :destroy]
  after_save :reset_map_history_statuses_cache, on: [:update, :create, :destroy]

  belongs_to :diffusion_history

  attr_accessor :reset_map_history_statuses_cache

  def clear_map_history_statuses
    cache_key = "map_history_statuses"
    Rails.cache.delete(cache_key)
    debugger
    DiffusionHistoryStatus.map_history_statuses
    debugger
  end

  def clear_map_history_statuses_on_save
    debugger
    if self.changed?
      self.reset_map_history_statuses_cache = true
    end
  end

  def reset_map_history_statuses_cache
    clear_map_history_statuses if self.reset_map_history_statuses_cache
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
