module SecurityPolicy
  @config = nil
  class << self
    def load_file
      return if @config && !Rails.env.development?
      @config = YAML.load_file("#{Rails.root}/config/security_policy.yml")
    end

    def respond_to_missing?(method)
      load_file
      @config.key? method
    end

    def method_missing(method, *_args, &_block)
      load_file
      set = @config.send(:[], method.to_s)
      raise "No policy for '#{method}'" unless set.present?
      if set['type'] == 'array'
        ArrayPolicyChecker.new(set)
      elsif set['type'] == 'integer'
        IntegerPolicyChecker.new(set)
      end
    end
  end

  class PolicyChecker
    def initialize(policy_set)
      @set = policy_set
    end

    def default
      @set['default']
    end

    def secure
      @set['secure']
    end

    def insecure?(method)
      !secure? method
    end
  end
  class ArrayPolicyChecker < PolicyChecker
    def secure?(value)
      @set['secure'].include? value
    end
  end
  class IntegerPolicyChecker < PolicyChecker
    def secure?(method)
      method >= @set['min_secure'].to_i
    end
  end
end
