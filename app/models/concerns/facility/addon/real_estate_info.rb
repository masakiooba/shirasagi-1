module Facility::Addon
  module RealEstateInfo
    extend ActiveSupport::Concern
    extend SS::Addon

    included do |base|
      base.extend ClassMethods

      field :registration_num, type: String
      field :area_size, type: String
      field :price, type: String
      field :floor_layout, type: String
      field :build_at, type: String

      before_save :set_field
    end

    REAL_ESTATE_FIELD = %w(area_size floor_layout build_at price registration_num)
    REGISTRATION_NUM_KEYS = %w(登録番号 番号)
    AREA_SIZE_KEYS = %(面積 専有面積 土地面積)
    PRICE_KEYS = %w(価格 希望価格 賃料 希望賃料 家賃 希望家賃 坪単価 売却希望価格 賃貸希望価格)
    FLOOR_LAYOUT_KEYS = %w(間取 間取り)
    BUILD_AT_KEYS = %w(築年月 築年 建築年)

    def set_field
      return nil if additional_info.nil? || additional_info.blank?
      hash ={}
      hash_update_attributes = {}
      additional_info.map { |x| hash[x[:field]] = x[:value] }
      REAL_ESTATE_FIELD.each do |field|
        hash.keys.each do |key|
          if (self.class.to_s + "::" + (field + "_keys").upcase).constantize.include?(key)
            send(field + '=', hash[key])
            #hash_update_attributes[field]= hash[key]
          end
        end
      end
    end

    def set_registration_id
      return nil if additional_info.nil? || additional_info.blank?
      hash = {}
      additional_info.map{|x| hash[x[:field]] = x[:value]}
      if hash.keys.include?("登録番号")
        self.registration_id = hash["登録番号"]
      else
        self.registration_id = nil
      end
    end

    module ClassMethods
    end
  end
end
