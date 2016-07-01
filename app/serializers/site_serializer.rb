class SiteSerializer < ActiveModel::Serializer
  attributes(
    :id,
    :name,
    :fqdn,
    :tagline,
    :description,
    :gtm_id,
    :promotion_url,
    :promotion_tag,
    :sns_share_caption,
    :twitter_account,
    :logo_image_url,
    :js_url,
    :css_url,
    :favicon_image_url,
    :mobile_favicon_image_url,
    :head_tag,
    :home_url,
    :ad_client
  )

  has_many :categories
  has_many :links
end
