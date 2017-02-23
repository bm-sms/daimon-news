class Ranking::Report
  ReportingApi = Ranking::ApiClient::ReportingApi

  def initialize(site)
    @site = site
  end

  def ranked_post_public_ids
    report_rows.select(&:valid?).sort_by(&:ranking_score).reverse.map(&:public_id)
  end

  private

  def api_client
    @api_client ||= Ranking::ApiClient.new
  end

  def api_request
    ReportingApi::GetReportsRequest.new(
      report_requests: [ReportingApi::ReportRequest.new(
        view_id: @site.analytics_viewid,
        metrics: [ReportingApi::Metric.new(expression: "ga:uniquePageviews", alias: "views")],
        dimensions: [ReportingApi::Dimension.new(name: @site.ranking_dimension)],
        date_ranges: [
          ReportingApi::DateRange.new(start_date: "14DaysAgo", end_date: "8DaysAgo"),
          ReportingApi::DateRange.new(start_date: "7DaysAgo", end_date: "1DaysAgo")
        ],
        order_bys: [ReportingApi::OrderBy.new(field_name: "ga:uniquePageviews", sort_order: "DESCENDING")],
        page_size: 1000,
        filters_expression: "ga:pagePath=~^/[0-9]+"
      )]
    )
  end

  def pageview_report_of_post
    api_client.report({
                        request: api_request,
                        stubfile: "test/fixtures/popular_posts_data_of_google_analytics_api.json"
                      })
  end

  def report_rows
    Array.wrap(pageview_report_of_post[:reports].first[:data][:rows]).map do |row|
      public_id = row[:dimensions].first.match(/\d+/).to_s.to_i
      older_value = row[:metrics].first[:values].first.to_f
      newer_value = row[:metrics].second[:values].first.to_f

      ReportRow.new(public_id, older_value, newer_value)
    end
  end

  ReportRow = Struct.new(:public_id, :older_value, :newer_value) do
    def ranking_score
      newer_value / older_value
    end

    def valid?
      older_value >= 1 && newer_value > 30
    end
  end
end
