class RedirectRule < ActiveRecord::Base
  before_validation :decode_request_path
  before_validation :decode_destination
  belongs_to :site, inverse_of: :redirect_rules

  validates :request_path, presence: true
  validates :request_path, uniqueness: {scope: :site_id}
  validates :destination, presence: true
  validate :request_path_is_relative_path?
  validate :request_path_has_fragment_string?
  validate :request_path_has_query_string?
  validate :request_equal_destination?
  validate :redirect_loop?

  private

  def decode_request_path
    self.request_path = URI.decode_www_form_component(self.request_path)
  end

  def decode_destination
    destination = Addressable::URI.parse(URI.decode_www_form_component(self.destination))
    if destination.host
      destination.host = SimpleIDN.to_unicode(destination.host)
      self.destination = destination.to_s
    else
      true
    end
  end

  def add_error_request_path(key)
    errors.add(:request_path, key)
  end

  def request_path_is_relative_path?
    add_error_request_path(:not_relative_path) unless request_path.start_with?("/")
  end

  def request_path_has_fragment_string?
    add_error_request_path(:has_fragment_string) if Addressable::URI.parse(request_path).fragment.present?
  end

  def request_path_has_query_string?
    add_error_request_path(:has_query_string) if Addressable::URI.parse(request_path).query.present?
  end

  def request_equal_destination?
    destination_uri = Addressable::URI.parse(destination).freeze
    if request_path == destination_uri.path && (destination_uri.hostname == site.fqdn || destination_uri.relative?)
      add_error_request_path(:not_equal_destination)
    end
  end

  def redirect_loop?
    redirect_loop_rule = site.redirect_rules.find do |redirect_rule|
      redirect_rule.request_path == destination && redirect_rule.destination == request_path
    end
    errors.add(:destination, :redirect_loop) if redirect_loop_rule.present?
  end
end
