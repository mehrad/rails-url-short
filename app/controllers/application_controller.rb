class ApplicationController < ActionController::Base
    def not_found
        raise ActionController::RoutingError.new('Not Found')
    rescue
        render_404
    end

    def not_found
        raise ActionController::RoutingError.new('Bad Request')
    rescue
        render_400
    end

    def render_404
        render file: "#{Rails.root}/public/404", status: :not_found
    end

    def render_400
        render file: "#{Rails.root}/public/400", status: :bad_request
    end
end
