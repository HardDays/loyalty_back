Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new 

# register limit


Rack::Attack.throttle('limit all login', limit: 5, period: 30) do |req|
    if req.path.start_with?('/auth') and req.post?
        req.ip
    end
end

Rack::Attack.throttle('limit all register', limit: 1, period: 10) do |req|
    if (req.path == '/creators' or req.path == '/clients' or req.path == '/operators') and req.post?
        req.ip
    end
end

Rack::Attack.throttle('limit etc', limit: 1, period: 10) do |req|
    if (req.path == '/cards' or req.path == '/stores' or req.path == '/loyalty_programs' or 
            req.path == '/vk/groups' or req.path == '/tariff_plans/purchase' or req.path == '/sms') and req.post?
        req.ip
    end
end

Rack::Attack.throttle('limit client points create', limit: 1, period: 5) do |req|
    if /\/clients\/\d+\/points/.match(req.path) and req.post?
        req.env['HTTP_AUTHORIZATION']
    end
end

Rack::Attack.throttle('limit orders create', limit: 1, period: 5) do |req|
    if req.path.start_with?('/orders') and req.post?
        req.env['HTTP_AUTHORIZATION']
    end
end