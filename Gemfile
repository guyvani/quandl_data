source "https://rubygems.org"
gemspec

use_local_gems = ENV['BUNDLE_LOCAL_GEMS'] == "true" && ENV['BUNDLE_LOCAL_DIR']
local_gem_dir = ENV['BUNDLE_LOCAL_DIR']

if use_local_gems
  gem 'quandl_operation', path: "#{local_gem_dir}/quandl/operation"
  gem 'quandl_babelfish', path: "#{local_gem_dir}/quandl/babelfish"
end
