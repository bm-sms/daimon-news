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
      rule = redirect_rule
      if rule.present?
        destination = ERB::Util.html_escape(rule.destination)

        [301, {"Location" => destination}, [%Q(You are being redirected <a href="#{destination}">#{destination}</a>)]]
      else
        app.call(env)
      end
    end

    private

    def redirect_rule
      site = Site.find_by!(fqdn: request_host)
      site.redirect_rules.find_by(request_path: request_path)&.freeze
    end

    def request_host
      SimpleIDN.to_unicode(env["HTTP_HOST"].split(":").first)
    end

    def request_path
      URI.decode_www_form_component(env["PATH_INFO"])
    end
  end
end
