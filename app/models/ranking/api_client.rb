require "googleauth/stores/redis_token_store"
require "google/apis/analyticsreporting_v4"

class Ranking::ApiClient
  ReportingApi = Google::Apis::AnalyticsreportingV4

  def report(request:, stubfile:)
    if use_api?
      report_from_google_api(request)
    else
      report_from_local_file(stubfile)
    end
  end

  private

  def use_api?
    Rails.application.config.x.google_api_client_email && Rails.application.config.x.google_api_private_key
  end

  def report_from_google_api(request)
    client.batch_get_reports(request).to_h
  end

  def report_from_local_file(stubfile)
    path = Rails.root.join(stubfile).to_s
    JSON.parse(File.read(path), {symbolize_names: true})
  end

  def json_key_io
    json = {
      client_email: Rails.application.config.x.google_api_client_email,
      private_key: Rails.application.config.x.google_api_private_key.gsub("\\n", "\n")
    }
    StringIO.new(json.to_json, "r+")
  end

  def client
    @client ||= ReportingApi::AnalyticsReportingService.new.tap do |c|
      c.authorization = Google::Auth::ServiceAccountCredentials.make_creds(
        json_key_io: json_key_io,
        scope: ["https://www.googleapis.com/auth/analytics.readonly"]
      )
    end
  end
end
