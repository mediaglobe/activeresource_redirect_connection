# coding: utf-8
require File.expand_path('../lib/active_resource_redirect_connection/version', __FILE__)

Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '2.2.2'
  s.required_ruby_version = '>= 2.0.0'
  s.platform = Gem::Platform::RUBY

  s.name = 'activeresource_redirect_connection'
  s.version = ActiveResourceRedirectConnection::VERSION
  s.date = '2016-07-25'
  s.summary = ''
  s.authors = ['Tom Streller']
  s.email = 'tom.streller.sternzeit@gmail.com'
  s.license = 'AGPL-3.0'
  s.homepage = 'https://github.com/sternzeit/activeresource_redirect_connection'
  s.metadata = { 'issue_tracker' => 'https://github.com/sternzeit/activeresource_redirect_connection/issues' }

  s.files = Dir['{lib}/**/*.rb', '*.md']
  s.require_path = 'lib'

  s.add_runtime_dependency 'activeresource', '~> 4.1'

  # s.add_development_dependency 'rspec', '~> 3.5'
  # s.add_development_dependency 'webmock', '~> 2.1'
  # s.add_development_dependency 'capybara', '~> 2.7'
end
