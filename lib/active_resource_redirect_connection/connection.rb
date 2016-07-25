require 'activeresource'

ActiveResource::Connection.class_eval do

  private

  def request(method, path, *arguments)
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

    raise(ActiveResource::Redirection.new(response)) unless response.header['Location'].present?

    location = URI.parse(response.header['Location']).path

    return with_auth { request(:get, location, arguments.select { |argument| argument.is_a? Hash }.last) }
  end

end
