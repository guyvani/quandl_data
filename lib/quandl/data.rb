require "quandl/data/version"

require 'active_model'
require "active_support"
require "active_support/inflector"
require "active_support/core_ext/hash"
require "active_support/core_ext/object"

require 'quandl/support'

require "quandl/operation"
require 'quandl/babelfish'
require 'quandl/error/date_parse_error'

require 'quandl/data/attributes'
require 'quandl/data/cleaning'
require 'quandl/data/enumerator'
require 'quandl/data/operations'
require 'quandl/data/format'
require 'quandl/data/validations'
require 'quandl/data/logging'

module Quandl
class Data
  
  include ActiveModel::Validations
  
  include Attributes
  include Cleaning
  include Enumerator
  include Operations
  include Validations
  include Logging if defined?(QUANDL_LOGGER) && QUANDL_LOGGER == true
end
end
