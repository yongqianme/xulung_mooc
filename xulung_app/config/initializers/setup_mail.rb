
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
:address => "smtp.domain.org",
:port => 1000,
:domain => "domain.org",
:user_name => "username",
:password => "password",
:authentication => "plain",
:enable_starttls_auto => true
}
