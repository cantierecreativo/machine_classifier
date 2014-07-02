require 'spec_helper'
require 'google/api_client'

describe MachineClassifier::Authorizer do
  let(:configuration) do
    double(
      'MachineClassifier::Configuration',
      private_key: private_key,
      private_key_password: 'foo',
      developer_email: 'dev@example.com'
    )
  end
  let(:private_key) { Base64.encode64 'BinaryPrivateData' }

  subject do
    MachineClassifier::Authorizer.new(configuration)
  end

  describe '#initialize' do
    it 'expects a configuration' do
      expect(subject.configuration).to eq(configuration)
    end
  end

  describe '#authorize' do
    let(:private_key_decoded) { 'BinaryPrivateData' }
    let(:pkcs12_key) { 'pkcs12_key' }
    let(:pkcs12) { double('PKCS12', key: pkcs12_key) }
    let(:authorization) { double('Authorization') }
    let(:service_account) { double('Google::APIClient::JWTAsserter', authorize: authorization) }
    let(:prediction_url) { 'https://www.googleapis.com/auth/prediction' }

    before do
      allow(OpenSSL::PKCS12).to receive(:new).with(private_key_decoded, configuration.private_key_password).and_return(pkcs12)
      allow(Google::APIClient::JWTAsserter).to receive(:new).with(configuration.developer_email, prediction_url, pkcs12_key).and_return(service_account)
    end

    it 'returns an authorization' do
      expect(subject.authorize).to eq(authorization)
    end
  end
end

