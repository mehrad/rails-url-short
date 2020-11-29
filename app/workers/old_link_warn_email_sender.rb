class OldLinkWarnEmailSender
    include Sidekiq::Worker

    def perform(*args)
        # TODO(Mahard): send mail to users where any of their urls
        # expiration date or updated time are bigger than 2 months
    end
  end