class UrlAddCountWorker
    include Sidekiq::Worker
    sidekiq_options retry: 5

    def perform(*args)
        # TODO(Mahard):
        # url = Url.find(args[:id])
        # url.add_click_count!
    end
  end