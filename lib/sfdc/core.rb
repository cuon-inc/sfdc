module Sfdc
  module Core
    class ArgumentError < StandardError; end

    class RecordInvalid < StandardError; end

    class RecordNotFound < StandardError; end

    def self.find(object_name, id)
      raise RecordNotFound, "Couldn't find #{id}" if id.blank?

      begin
        record = client.find(object_name, id)
        record.attrs
      rescue ::Restforce::NotFoundError
        raise RecordNotFound, "Couldn't find #{id}"
      end
    end

    def self.find_by(object_name, **args)
      conditions = args.map do |key, value|
        if value.is_a?(String)
          "#{key} = '#{value}'"
        elsif value.nil?
          "#{key} = null"
        else
          "#{key} = #{value}"
        end
      end
      conditions = conditions.join(" AND ")
      query = <<-QUERY.squish
        select Id
        from #{object_name}
        where #{conditions}
      QUERY

      records = client.query(query)

      begin
        find(object_name, records.first&.Id)
      rescue RecordNotFound
        nil
      end
    end

    def self.last(object_name)
      query = <<-QUERY.squish
        select Id
        from #{object_name}
        order by Id desc
        limit 1
      QUERY

      records = client.query(query)

      begin
        find(object_name, records.first&.Id)
      rescue RecordNotFound
        nil
      end
    end

    def self.create!(object_name, params)
      raise ArgumentError, "wrong number of arguments" if object_name.nil? || params.nil?

      id = client.create!(object_name, params)
      config.logger.debug { "[#{object_name}] Create by: #{id}" }
      find(object_name, id)
    rescue ::Restforce::ResponseError => e
      errors = []
      e.response[:body].each do |error|
        config.logger.error(error)
        errors << error["message"]
      end
      raise RecordInvalid, errors.join(" ")
    end

    def self.update!(object_name, id, params)
      raise ArgumentError, "wrong number of arguments" if object_name.nil? || id.nil? || params.nil?

      client.update!(object_name.to_s, { Id: id }.merge(params))
      config.logger.debug { "[#{object_name}] Update by: #{id}" }
      find(object_name, id)
    rescue ::Restforce::ResponseError => e
      errors = []
      e.response[:body].each do |error|
        config.logger.error(error)
        errors << error["message"]
      end
      raise RecordInvalid, errors.join(" ")
    end

    def self.client
      @client ||= ::Restforce.new
    end

    def self.config
      ::Sfdc.config
    end
  end
end
