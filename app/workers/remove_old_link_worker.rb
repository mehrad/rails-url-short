class RemoveOldLinksWorker
    include Sidekiq::Worker

    def perform(*args)
        # TODO(Mahard): destory Urls where expiration date or updated at bigger than 5 month
    end
  end