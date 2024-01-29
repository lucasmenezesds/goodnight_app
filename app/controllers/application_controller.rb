# frozen_string_literal: true

class ApplicationController < ActionController::API
  private

  def paginate(collection, serializer, options = {})
    paginated_collection = collection.page(page).per(per_page)

    pagination_result(paginated_collection, options, paginated_collection.total_count, serializer)
  end

  def paginate_at_option_data(collection, serializer, total_count, options: {})
    pagination_result(collection, options, total_count, serializer)
  end

  def pagination_result(collection, options, total_count, serializer)
    { data: serializer.render_as_hash(collection, **options),
      pagination: {
        total_items: total_count,
        page_number: page,
        per_page: per_page
      } }
  end

  def page
    default_page = 1
    pagination_params.fetch(:page, default_page).to_i
  end

  def per_page
    per_page = pagination_params.fetch(:per_page, Kaminari.config.default_per_page).to_i
    [per_page, Kaminari.config.max_per_page].min
  end

  def pagination_params
    params.permit(:page, :per_page, :user_id)
  end
end
