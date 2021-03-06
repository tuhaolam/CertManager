class Settings::Group
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  include ActiveModel::ForbiddenAttributesProtection
  include ActiveModel::Callbacks
  define_model_callbacks :update

  def initialize
    @changed_attributes = []

    load_values # Pre-load setting values
  end

  def class_name
    self.class.name.split('::').last.underscore
  end

  def self.config_keys(*keys)
    keys.each do |key|
      define_setting_method(key)
    end
  end

  def save
    run_callbacks :update do
      @changed_attributes.each(&:save)
    end
  end

  def save!
    run_callbacks :update do
      @changed_attributes.each(&:save!)
    end
  end

  def persisted?
    true
  end

  def assign_attributes(values)
    return unless values
    sanitize_for_mass_assignment(values).each do |key, value|
      send("#{key}=", value)
    end
  end

  private

  def load_values
    settings = Setting.where(config_group: class_name)
    @settings = {}
    settings.each do |setting|
      @settings[setting.key] = setting.value
    end
  end

  def self.define_setting_method(key)
    define_method(key) do
      config_value(key)
    end
    define_method("#{key}=") do |value|
      setting = Setting.find_by(config_group: class_name, key: key) || Setting.new
      setting.key = key
      setting.config_group = class_name
      setting.value = value
      @changed_attributes << setting
    end
    define_method("#{key}_changed?") do
      @changed_attributes.include? key
    end
  end

  private_class_method :define_setting_method

  def config_value(key)
    key = key.to_s
    return @settings[key] if @settings.key? key
    val = Setting.find_by(config_group: class_name, key: key)
    val.value if val
  end
end
