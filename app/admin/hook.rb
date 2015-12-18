ActiveAdmin.register Hook do
  permit_params :site_id

  form do |f|
    f.semantic_errors
    f.inputs :site
    f.actions
  end

  before_create do |hook|
    hook.token = SecureRandom.uuid
  end

  index do
    selectable_column
    column :id
    column :token_url do |hook|
      trigger_hook_url(hook.token, host: hook.site.fqdn)
    end

    actions
  end
end
