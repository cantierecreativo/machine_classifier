module MachineClassifier
  class Authorizer < Struct.new(:configuration)
    SERVICE_URL = 'https://www.googleapis.com/auth/prediction'

    def authorize
      service_account.authorize
    end

    private

    def service_account
      @service_account ||= Google::APIClient::JWTAsserter.new(
        configuration.developer_email,
        SERVICE_URL,
        key
      )
    end

    def key
      OpenSSL::PKCS12.new(configuration.private_key, configuration.private_key_password).key
    end
  end
end
