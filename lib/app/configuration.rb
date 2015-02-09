require 'ostruct'

module CertManager
  module Configuration
    @config = nil
    public
    class << self
      def load
        yaml = YAML.load_file("#{Rails.root}/config/configuration.yml")
        @config = {}
        if yaml.is_a?(Hash)
          @config.merge!(yaml['default']) if yaml['default']
          @config.merge!(yaml[Rails.env]) if yaml[Rails.env]
        end

        @config = HashWithIndifferentAccess.new(@config)

        if email_delivery
          email_delivery.each do |key, value|
            ActionMailer::Base.send("#{key}=", value)
          end
        end
      end
      def redis_client
        CertManager::InstrumentedRedis.new redis
      end
      def redis_client_no_metrics
        Redis.new redis
      end

      def method_missing(method, *args, &block)
        load unless @config
        @config[method]
      end
    end
  end
end