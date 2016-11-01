module Cms::Addon
  module AdditionalInfo
    extend ActiveSupport::Concern
    extend SS::Addon

    included do |base|
      base.extend ClassMethods
      field :additional_info, type: Cms::Extensions::AdditionalInfo

      permit_params additional_info: [ :field, :value ]
    end

    def additional_info_hash
      return "" if additional_info.blank?
      hash = {}
      additional_info.map{|x| hash[x[:field]] = x[:value]}
      hash
    end

    def additional_info_keys
      return "" if additional_info.blank?
      additional_info_hash.keys
    end

    module ClassMethods

      def order_by_area(asc_or_desc)
        sort = []
        hash ={}
        sort_nil = []
        criteria.each do |c|
          if c.additional_info_keys.include?("登録番号")
            hash[c.id] = c.additional_info_hash["登録番号"]
          else
            sort_nil << c.id
          end
        end
        case asc_or_desc
        when "asc"
          sort = hash.sort{ |(k1, v1), (k2, v2)| v1 <=> v2 }.map{|k,v| k}
        when "desc"
          sort = hash.sort{ |(k1, v1), (k2, v2)| v2 <=> v1 }.map{|k,v| k}
        end
        sort + sort_nil
        #criteria.find(sort + sort_nil)
      end
    end
  end
end
