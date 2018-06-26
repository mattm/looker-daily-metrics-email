require "looker-sdk"
require "mail"
require "erb"

module DailyMetricsEmail
    def self.run
    	@template_variables = {
    		new_customers_yesterday: look_value(123)
    	}

    	configure_email
    	template = ERB.new(File.read("template.erb")).result(binding)
    	subject = "Metrics for " + Date.today.strftime("%a, %B %e")
        mail = Mail.new do
            from "Daily Metrics Report <" + ENV["EMAIL_FROM"] + ">"
            to ENV["EMAIL_TO"]
            subject subject
            content_type "text/html; charset=UTF-8"
          body template
        end

        mail.deliver!
    end

    def self.configure_email
        Mail.defaults do
            delivery_method :smtp, {
                address: ENV["EMAIL_SMTP"],
                port: 587,
                domain: ENV["EMAIL_DOMAIN"],
                user_name: ENV["EMAIL_USER_NAME"],
                password: ENV["EMAIL_PASSWORD"],
                authentication: "plain",
                enable_starttls_auto: true
            }
        end
    end

    def self.look_value(look_id)
		sdk.alive
		sdk.run_look(look_id, "json").first.to_hash.values.first
    end

    def self.sdk
        @sdk ||= begin
            LookerSDK::Client.new(
                client_id: ENV["LOOKER_CLIENT_ID"],
                client_secret: ENV["LOOKER_CLIENT_SECRET"],
                api_endpoint: ENV["LOOKER_API"],
                connection_options: { request: { timeout: 3600, open_timeout: 30 } }
            )
        end
    end
end

DailyMetricsEmail.run
