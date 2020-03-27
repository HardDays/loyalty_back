RailsAdmin.config do |config|

  if Rails.env.production?
    config.authenticate_with do
      authenticate_or_request_with_http_basic('Login required') do |email, password|
        if email == Rails.configuration.admin_login && password == Rails.configuration.admin_password
          true
        end
      end
    end
  end

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
