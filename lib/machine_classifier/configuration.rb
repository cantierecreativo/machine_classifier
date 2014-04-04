module MachineClassifier
  class Configuration
    ATTRIBUTES = [
      :api_version,
      :application_name,
      :application_version,
      :developer_email,
      :model,
      :private_key,
      :private_key_password,
      :project
    ]

    ATTRIBUTES.each { |attribute| attr_accessor attribute }

    def initialize
      yield self if block_given?
    end

    def valid?
      ATTRIBUTES.each do |attribute|
        return false if self.send(attribute).nil? || self.send(attribute).empty?
      end
      true
    end
  end
end
