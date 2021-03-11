class Vamc < ApplicationRecord

  extend FriendlyId
  friendly_id :common_name, use: :slugged

  belongs_to :visn

  def self.get_practices_created_by_vamc(station_number)
    #Practice.joins("join practice_origin_facilities on practice_origin_facilities.practice_id = practice.id WHERE practice_origin_facilities.station_number = '#{station_number}';").to_a

    #PracticeOriginFacility.where(facility_id: station_number)
    sql = "select p.* from practices p join practice_origin_facilities pof on pof.practice_id = p.id where pof.facility_id = '#{station_number}'";
    ActiveRecord::Base.connection.execute(sql)
  end

  def self.get_adoptions_by_vamc(station_number)
    DiffusionHistory.where(facility_id: station_number).count
  end

  def self.get_categories
    Category.all.order('name')
  end

  def self.get_all_vamcs(order_by = "facility")
    sql = "select va.id, va.visn_id, va.station_number, va.common_name, va.official_station_name, va.fy17_parent_station_complexity_level, vi.number as visn_number, "
    sql += "(select count(*) from practice_origin_facilities p where p.facility_id = va.station_number) practices_created, "
    sql += "(select count(*) from diffusion_histories d where d.facility_id = va.station_number) adoptions "
    sql += "from vamcs va join visns vi on va.visn_id = vi.id "
    if order_by == "facility"
      sql += "order by official_station_name;"
    elsif order_by == "common_name"
      sql += "order by common_name;"
    elsif order_by == "visn"
      sql += "order by visn_number;"
    elsif order_by == "type"
      sql += "order by fy17_parent_station_complexity_level;"
    elsif order_by == "created"
      sql += "order by practices_created;"
    elsif order_by == "adoptions"
      sql += "order by adoptions;"
    end

    ActiveRecord::Base.connection.execute(sql).to_a
  end

  def self.get_visns
    Visn.all.order('number')
  end

  def self.get_types
    Vamc.select(:fy17_parent_station_complexity_level).distinct.order(:fy17_parent_station_complexity_level)
  end
end
