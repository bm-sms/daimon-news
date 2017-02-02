sites = Site.where.not(analytics_viewid: [nil, ""])
sites.each do |site|
  PopularPostBuilder.build(site)
end
