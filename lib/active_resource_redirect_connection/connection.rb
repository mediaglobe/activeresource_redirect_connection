require 'activeresource'

ActiveResource::Connection.class_eval do
  REDIRECT_LIMIT = 10

  def get(path, headers = {})
    with_auth { request(:get, path, REDIRECT_LIMIT, build_request_headers(headers, :get, self.site.merge(path))) }
  end

  def delete(path, headers = {})
    with_auth { request(:delete, path, REDIRECT_LIMIT, build_request_headers(headers, :delete, self.site.merge(path))) }
  end

  def patch(path, body = '', headers = {})
    with_auth { request(:patch, path, REDIRECT_LIMIT, body.to_s, build_request_headers(headers, :patch, self.site.merge(path))) }
  end

  def put(path, body = '', headers = {})
    with_auth { request(:put, path, REDIRECT_LIMIT, body.to_s, build_request_headers(headers, :put, self.site.merge(path))) }
  end

  def post(path, body = '', headers = {})
    with_auth { request(:post, path, REDIRECT_LIMIT, body.to_s, build_request_headers(headers, :post, self.site.merge(path))) }
  end

  def head(path, headers = {})
    with_auth { request(:head, path, REDIRECT_LIMIT, build_request_headers(headers, :head, self.site.merge(path))) }
  end

  private

  def request(method, path, limit, *arguments)
    result = ActiveSupport::Notifications.instrument("request.active_resource") do |payload|
      payload[:method]      = method
      payload[:request_uri] = "#{site.scheme}://#{site.host}:#{site.port}#{path}"
      payload[:result]      = http.send(method, path, *arguments)
    end
    handle_response(result)
  rescue Timeout::Error => e
    raise TimeoutError.new(e.message)
  rescue OpenSSL::SSL::SSLError => e
    raise SSLError.new(e.message)
  rescue ActiveResource::Redirection => e
    response = e.response

    raise(ActiveResource::Redirection.new(response)) if limit <= 0
    raise(ActiveResource::Redirection.new(response)) unless response.header['Location'].present?

    location = URI.parse(response.header['Location']).path

    return with_auth { request(:get, location, limit - 1, arguments.select { |argument| argument.is_a? Hash }.last) }
  end

end
