class DiffusionHistoryStatus < ApplicationRecord

  belongs_to :diffusion_history

  attr_accessor :reset_map_history_statuses_cache

  def clear_map_history_statuses
    cache_key = "map_history_statuses"
    Rails.cache.delete(cache_key)
    DiffusionHistoryStatus.map_history_statuses
  end

  def clear_map_history_statuses_on_change
    if self.changed?
      self.reset_map_history_statuses_cache = true
    end
  end

  def reset_map_history_statuses
    clear_map_history_statuses if self.reset_map_history_statuses
  end

  def self.map_history_statuses
    Rails.cache.fetch('map_history_statuses') do
      DiffusionHistoryStatus.all.reject { |dh| !dh.diffusion_history.practice.published }
    end
  end

  # def self.map_statuses_by_history(dh)
  #   # debugger
  #   Rails.cache.fetch("history_#{dh.id}_status") do
  #     DiffusionHistoryStatus.order(id: :desc).where(diffusion_history_id: dh.id)
  #   end
  # end
end
