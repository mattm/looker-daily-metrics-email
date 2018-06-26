require "looker-sdk"
require "mail"
require "erb"

module DailyMetricsEmail
	EXAMPLE_LOOK_ID = 628
	LOOKER_API_ENDPOINT = "https://example.looker.com:19999/api/3.0"
	EMAIL_SMTP = "smtp.example.com"
	EMAIL_DOMAIN = "example.com"
	EMAIL_FROM = "you@example.com"
	EMAIL_TO = "team@example.com"

	def self.run
		@template_variables = {
			new_customers_yesterday: look_value(EXAMPLE_LOOK_ID)
		}

		configure_email
		template = ERB.new(File.read("template.erb")).result(binding)
		subject = "Metrics for " + Date.today.strftime("%a, %B %e")
		mail = Mail.new do
			from "Daily Metrics Report <" + EMAIL_FROM + ">"
			to EMAIL_TO
			subject subject
			content_type "text/html; charset=UTF-8"
		  body template
		end

		mail.deliver!
	end

	def self.configure_email
		Mail.defaults do
			delivery_method :smtp, {
				address: EMAIL_SMTP,
				port: 587,
				domain: EMAIL_DOMAIN,
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
				api_endpoint: LOOKER_API_ENDPOINT,
				connection_options: { request: { timeout: 3600, open_timeout: 30 } }
			)
		end
	end
end

DailyMetricsEmail.run
