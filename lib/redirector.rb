class Redirector
  def initialize(application)
    @application = application
  end

  def call(environment)
    Responder.new(@application, environment).response
  end

  class Responder
    attr_reader :app, :env

    def initialize(application, environment)
      @app = application
      @env = environment
    end

    def response
      site = Site.find_by(fqdn: request_host)
      redirect_rule = RedirectRule.find_by(site_id: site.id, request_path: request_path)
      if redirect_rule.present?
        [301, {"Location" => redirect_rule.destination},
          [%{You are being redirected <a href="#{redirect_rule.destination}">#{redirect_rule.destination}</a>}]]
      else
        app.call(env)
      end
    end

    private

    def request_host
      env["HTTP_HOST"].split(":").first
    end

    def request_path
      env["PATH_INFO"]
    end
  end
end
