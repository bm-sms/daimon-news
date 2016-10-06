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
      rule = redirect_rule.freeze
      if rule.present?
        [301, {"Location" => rule.destination}, [%Q(You are being redirected <a href="#{rule.destination}">#{rule.destination}</a>)]]
      else
        app.call(env)
      end
    end

    private

    def redirect_rule
      site = Site.find_by(fqdn: request_host)
      RedirectRule.find_by(site_id: site.id, request_path: request_path) if site.present?
    end

    def request_host
      env["HTTP_HOST"].split(":").first
    end

    def request_path
      env["PATH_INFO"]
    end
  end
end
