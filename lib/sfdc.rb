require "sfdc/version"
require "sfdc/base"
require "sfdc/config"

require "active_support/all"
require "restforce"

module Sfdc
  autoload :Account, "sfdc/account"
  autoload :Contact, "sfdc/contact"
end
