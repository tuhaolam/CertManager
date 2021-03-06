class Settings::LetsEncrypt < Settings::Group
  config_keys :private_key_id, :endpoint

  def private_key?
    private_key_id.present?
  end

  def private_key
    PrivateKey.find(private_key_id)
  end
end
