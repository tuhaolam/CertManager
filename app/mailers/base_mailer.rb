class BaseMailer < ActionMailer::Base
  default from: CertManager::Configuration.auth[:mailer_sender]

  protected
  def default_url_options(opts=nil)
    {
      host: 'certmgr.devvm',
      protocol: 'http'
    }
  end
end