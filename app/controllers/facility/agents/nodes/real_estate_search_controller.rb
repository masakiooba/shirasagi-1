class Facility::Agents::Nodes::RealEstateSearchController < ApplicationController
  include Cms::NodeFilter::View
  helper Map::MapHelper
  append_view_path "app/views/facility/agents/addons/search_setting/view"
  append_view_path "app/views/facility/agents/addons/search_result/view"


  def index
    #set_query
    #set_markers
    @items = Facility::Node::Page.site(@cur_site).and_public.
      where(@cur_node.condition_hash).
      order_by(@cur_node.sort_hash)
  end

  def set_query
    @keyword      = params[:keyword]
    @category_ids = params[:category_ids].select(&:present?).map(&:to_i) rescue []
    @service_ids  = params[:service_ids].select(&:present?).map(&:to_i) rescue []
    @location_ids = params[:location_ids].select(&:present?).map(&:to_i) rescue []

    @q_category = @category_ids.present? ? { category_ids: @category_ids } : {}
    @q_service  = @service_ids.present? ? { service_ids: @service_ids } : {}
    @q_location = @location_ids.present? ? { location_ids: @location_ids } : {}

    @categories = Facility::Node::Category.in(_id: @category_ids)
    @services   = Facility::Node::Service.in(_id: @service_ids)
    @locations  = Facility::Node::Location.in(_id: @location_ids)
  end

  def set_markers
    @items = []
    @markers = []
    images = SS::File.all.map {|image| [image.id, image.url]}.to_h

    Facility::Map.site(@cur_site).and_public.each do |map|
      parent_path = ::File.dirname(map.filename)
      item = Facility::Node::Page.site(@cur_site).and_public.
        where(@cur_node.condition_hash).
        in_path(parent_path).
        search(name: @keyword).
        in(@q_category).
        in(@q_service).
        in(@q_location).first

      next unless item

      @items << item
      categories   = item.categories.entries
      category_ids = categories.map(&:id)
      image_id     = categories.map(&:image_id).first

      image_url = images[image_id]
      marker_info = view_context.render_marker_info(item)

      map.map_points.each do |point|
        point[:id] = item.id
        point[:html] = marker_info
        point[:category] = category_ids
        point[:image] = image_url if image_url.present?
        @markers.push point
      end
    end

    @items.sort_by!(&:name)
  end

end
