Rails.configuration.middleware.use Browser::Middleware do
  next unless browser.ie?
  case request.env["PATH_INFO"]
  when %r!/admin/.+!
    redirect_to admin_root_path
  when %r!/editor/.+!
    redirect_to editor_root_path
  end
end
