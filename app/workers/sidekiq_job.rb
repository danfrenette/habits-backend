require "sidekiq-scheduler"

class SidekiqJob
  include Sidekiq::Job

  module ErrorHandling
    DISABLE_RETRY_ON_ERRORS = ENV.fetch("DISABLE_SIDEKIQ_RETRY_ON_ERRORS", "")

    private

    def disable_retry?(error)
      disabled_errors = Array(DISABLE_RETRY_ON_ERRORS.split(",")).map(&:strip)
      disabled_errors.include?(error.class.name)
    end

    def handle_error(error)
      if disable_retry?(error)
        Rails.logger.error(error)
      else
        raise error
      end
    end
  end
end
