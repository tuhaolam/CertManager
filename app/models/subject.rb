class Subject < ActiveRecord::Base
  after_update :prune_empty
  after_initialize :prune_empty

  def to_s
    self.CN ? self.CN : self.OU
  end

  def to_r509
    subj = R509::Subject.new
    Subject.safe_attributes.each do |k|
      val = send(k)
      subj.send("#{k}=", val) if val
    end
    subj
  end

  def to_openssl
    subject = OpenSSL::X509::Name.new
    Subject.safe_attributes.each do |k|
      val = send(k)
      subject.add_entry(k.to_s, val) if val && !val.empty?
    end
    subject
  end

  def to_h
    {
      CN: self.CN,
      O: self.O,
      OU: self.OU,
      ST: self.ST,
      C: self.C
    }
  end

  def self.from_r509(subject)
    Subject.find_or_initialize_by(filter_params(subject.to_h))
  end

  def self.filter_params(params)
    params.slice(*Subject.attribute_names.map(&:to_sym))
  end

  def self.safe_attributes
    [:O, :OU, :C, :CN, :L, :ST]
  end

  private

  def prune_empty
    Subject.safe_attributes.each do |attrib|
      send("#{attrib}=", nil) if send(attrib) == ''
    end
  end
end
