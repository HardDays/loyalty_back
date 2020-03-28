class ApplicationController < ActionController::API
    # тут можно свои эксепшены мапить на статус коды
    Unauthorized = Class.new(StandardError)
    Forbidden = Class.new(StandardError)

    rescue_from ApplicationController::Unauthorized do |exception|
        render_to_string(status: 401)
    end

    rescue_from ApplicationController::Forbidden do |exception|
        render_to_string(status: 403)
    end

    rescue_from ActiveRecord::RecordNotFound do |exception|
        render_to_string(status: 404)
    end

end
