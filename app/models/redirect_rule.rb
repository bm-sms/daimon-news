class RedirectRule < ActiveRecord::Base
  after_save :after_change
  after_destroy :after_change

  belongs_to :site

  validates :request, presence: true
  validates :request, uniqueness: {scope: :site_id}
  validates :destination, presence: true
  validate :request_has_query_string?
  validate :request_equal_destination?
  validate :redirect_loop?

  private

  def request_has_query_string?
    uri = URI.parse(request)
    errors.add(:request, "クエリパラメーターは含めることができません") if uri.query.present?
  end

  def request_equal_destination?
    errors.add(:destination, "リダイレクト元とリダイレクト先は同じにできません") if request == destination
  end

  def redirect_loop?
    redirect_rule = RedirectRule.find_by(request: destination, destination: request)
    if redirect_rule.present?
      errors.add(:destination, "リダイレクトループが発生する設定は追加できません") unless redirect_rule.id == id
    end
  end

  def after_change
    Rails.application.reload_routes!
  end
end
