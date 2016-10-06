class RedirectRule < ActiveRecord::Base
  belongs_to :site

  validates :request_path, presence: true
  validates :request_path, uniqueness: {scope: :site_id}
  validates :destination, presence: true
  validate :request_path_is_relative_path?
  validate :request_path_has_fragment_string?
  validate :request_path_has_query_string?
  validate :request_equal_destination?
  validate :redirect_loop?

  private

  def add_error_request_path(key)
    errors.add(:request_path, key)
  end

  def request_path_is_relative_path?
    add_error_request_path(:not_relative_path) unless request_path.start_with?("/")
  end

  def request_path_has_fragment_string?
    add_error_request_path(:has_fragment_string) if URI.parse(request_path).fragment.present?
  end

  def request_path_has_query_string?
    add_error_request_path(:has_query_string) if URI.parse(request_path).query.present?
  end

  def request_equal_destination?
    if request_path == URI.parse(destination).path
      if URI.parse(destination).hostname == site.fqdn || URI.parse(destination).relative?
        add_error_request_path(:not_equal_destination)
      end
    end
  end

  def redirect_loop?
    redirect_rule = RedirectRule.find_by(site_id: site.id, request_path: destination, destination: request_path)
    if redirect_rule.present?
      errors.add(:destination, :redirect_loop) unless redirect_rule.id == id
    end
  end
end
