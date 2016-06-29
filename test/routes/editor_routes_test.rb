class EditorRoutesTest < ActionDispatch::IntegrationTest
  def setup
    @site = create(:site)
    @post = create(:post, :whatever, site: @site)
    @category = create(:category, site: @site)
    @fixed_page = create(:fixed_page, site: @site)
    @link = create(:link, site: @site)
    @credit_role = create(:credit_role, site: @site)
    @participant = create(:participant, site: @site)
    @serial = create(:serial, site: @site)
    @target_map = {
      "post" => @post,
      "category" => @category,
      "fixed_page" => @fixed_page,
      "link" => @link,
      "credit_role" => @credit_role,
      "participant" => @participant,
      "serial" => @serial
    }
    https!
    host! @site.fqdn
  end

  data do
    hash = {}
    hash["/editor"] = [nil, "/editor", "/sites/%{site_id}/editor"]
    @target_map.keys.each do |target|
      base_path = "/editor/#{target.pluralize}"
      hash[base_path] = [target, base_path, "/sites/%{site_id}#{base_path}"]
      hash["#{base_path}/new"] = [target, "#{base_path}/new", "/sites/%{site_id}#{base_path}/new"]
      hash["#{base_path}/:id"] = [target, "#{base_path}/%{id}", "/sites/%{site_id}#{base_path}/%{id}"]
      hash["#{base_path}/:id/edit"] = [target, "#{base_path}/%{id}/edit", "/sites/%{site_id}#{base_path}/%{id}/edit"]
    end
    hash
  end
  def test_redirect(data)
    target, path, expected = data
    target = @target_map[target]
    get path % {id: target&.id}
    assert_response(:moved_permanently)
    assert_redirected_to(expected % {id: target&.id, site_id: @site.id})
  end
end
