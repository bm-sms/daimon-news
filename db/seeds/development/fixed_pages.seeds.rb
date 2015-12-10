after 'development:sites' do
  site1 = Site.find_by!(name: 'site1')

  site1.fixed_pages.create!(
    slug:  'about',
    title: 'About Site 1',
    body: <<-EOS.strip_heredoc,
    # About Site 1

    Site 1 is:

    - A
    - B
    - C
    EOS
  )
  site1.fixed_pages.create!(
    slug:  'policy',
    title: 'Privacy Policy',
    body: <<-EOS.strip_heredoc,
    # Welcome to the Site 1 Policy

    ## Privacy Policy

    - A

    ## Information

    hi
    EOS
  )
end
