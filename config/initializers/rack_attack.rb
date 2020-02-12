Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new 

# register limit


Rack::Attack.throttle('limit all login', limit: 5, period: 30) do |req|
    if req.path.start_with?('/api/v1/auth') and req.post?
        req.ip
    end
end

Rack::Attack.throttle('limit all register', limit: 1, period: 10) do |req|
    if (req.path == '/api/v1/creators' or req.path == '/api/v1/clients' or req.path == '/api/v1/operators') and req.post?
        req.ip
    end
end

Rack::Attack.throttle('limit etc', limit: 1, period: 10) do |req|
    if (req.path == '/api/v1/cards' or req.path == '/api/v1/stores' or req.path == '/api/v1/loyalty_programs' or 
            req.path == '/api/v1/vk/groups' or req.path == '/api/v1/tariff_plans/purchase' or req.path == '/api/v1/sms') and req.post?
        req.ip
    end
end

Rack::Attack.throttle('limit client points create', limit: 1, period: 5) do |req|
    if /\/api\/v1\/clients\/\d+\/points/.match(req.path) and req.post?
        req.env['HTTP_AUTHORIZATION']
    end
end

Rack::Attack.throttle('limit orders create', limit: 1, period: 5) do |req|
    if req.path.start_with?('/api/v1/orders') and req.post?
        req.env['HTTP_AUTHORIZATION']
    end
end