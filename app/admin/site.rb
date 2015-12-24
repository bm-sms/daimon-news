ActiveAdmin.register Site do
  permit_params(
    :name,
    :js_url,
    :css_url,
    :fqdn,
    :tagline,
    :copyright,
    :bbs_enabled,
    :logo_url,
    :favicon_url,
    :mobile_favicon_url,
    :gtm_id,
    :content_header_url,
    :promotion_url,
    :sns_share_caption,
    :twitter_account,
    :ad_client,
    :ad_slot
  )

  form do |f|
    f.semantic_errors
    f.inputs(
      :name,
      :js_url,
      :css_url,
      :fqdn,
      :tagline,
      :copyright,
      :bbs_enabled,
      :logo_url,
      :favicon_url,
      :mobile_favicon_url,
      :gtm_id,
      :content_header_url,
      :promotion_url,
      :sns_share_caption,
      :twitter_account,
      :ad_client,
      :ad_slot
    )

    f.actions
  end
end
