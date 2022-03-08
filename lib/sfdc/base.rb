require "sfdc/core"

module Sfdc
  class Base
    def self.object_name
      name.split("::")[-1]
    end

    def self.find(id)
      Sfdc::Core.find(object_name, id)
    end

    def self.find_by(**args)
      Sfdc::Core.find_by(object_name, **args)
    end

    def self.last
      Sfdc::Core.last(object_name)
    end

    # params = {
    #   Name: "kakimoto-#{Time.zone.now.strftime("%Y%m%d%m%s")}"
    # }
    # Sfdc::Account.create!(params)
    # => Sfdc::Account
    # エラー発生
    # Sfdc::Account.create!({})
    # => ActiveRecord::RecordInvalid
    #
    # @return [Sfdc::Account]
    #
    def self.create!(params)
      Sfdc::Core.create!(object_name, params)
    end

    # Sfdc::Account.update!("001O000001y4HrpIAE", {Phone: "08011112222"})
    # @return [Sfdc::Account]
    #
    def self.update!(id, params)
      Sfdc::Core.update!(object_name, id, params)
    end
  end
end
