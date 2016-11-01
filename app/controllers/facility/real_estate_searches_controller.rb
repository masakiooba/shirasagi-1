class Facility::RealEstateSearchesController < ApplicationController
  include Cms::BaseFilter
  include Cms::NodeFilter

  model Facility::Node::RealEstateSearch

  prepend_view_path "app/views/cms/node/nodes"

  private
    def fix_params
      { cur_user: @cur_user, cur_site: @cur_site, cur_node: @cur_node }
    end

    def pre_params
      { route: "facility/real_estate_search" }
    end
end
