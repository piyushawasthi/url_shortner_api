class SortUrlsDatatable
  delegate :params, :h, :link_to, to: :@view

  def initialize(view, user_id)
    @view = view
    @user_id = user_id
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: ShortUrl.count,
      iTotalDisplayRecords: short_urls.total_entries,
      aaData: data
    }
  end

private

  def data
    short_urls.map do |short_url|
      [
        link_to(short_url.original_url, short_url.shorty, :target => "_blank"),
        link_to(short_url.shorty,  short_url.shorty, :target => "_blank"),
        (short_url.visits_count),
        link_to('Show', short_url) + ' | ' + link_to('Delete', short_url, method: :delete, data: { confirm: 'Are you sure?' }) + ' | ' +
        link_to('Show Geolocation', "/short_urls/#{short_url.id}/short_visits")
      ]
    end
  end

  def short_urls
    @short_urls ||= fetch_short_urls
  end

  def fetch_short_urls
    short_urls = ShortUrl.active_user(@user_id).order("#{sort_column} #{sort_direction}")
    short_urls = short_urls.page(page).per_page(per_page)
    if params[:sSearch].present?
      short_urls = short_urls.where("original_url like :search or shorty like :search", search: "%#{params[:sSearch]}%")
    end
    short_urls
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[original_url shorty visits_count]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end

