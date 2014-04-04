require 'spec_helper'
require 'json'

describe MachineClassifier::Client do
  let(:client_authorization) { double('ClientAuthorization') }
  let(:api_client) { double('Google::APIClient', authorization: client_authorization) }
  let(:authorizer) { double('MachineClassifier::Authorizer') }
  let(:configuration) do
    double(
      'MachineClassifier::Configuration',
      api_version: 'v1.6',
      application_name: 'MachineClassifier',
      application_version: 'v0.01',
      developer_email: 'foo@bar.it',
      model: 'name.of.model',
      private_key: '123AF',
      private_key_password: '123456',
      project: 'project.id'
    )
  end
  let(:prediction_settings) {}

  subject { MachineClassifier::Client.new(configuration) }

  before do
    allow(MachineClassifier::Authorizer).to receive(:new).and_return(authorizer)
    allow(Google::APIClient).to receive(:new).and_return(api_client)
  end

  describe '#initialize' do
    it 'expects a configuration parameter' do
      expect(subject.configuration).to eq(configuration)
    end
  end

  describe '#call' do
    let(:authorization) { double('Authorization') }
    let(:authorizer) { double('MachineClassifier::Authorizer', authorize: authorization) }
    let(:predict) { double('Predict') }
    let(:prediction_resource) { double('Prediction', trainedmodels: double('Hosted', predict: predict)) }
    let(:model) { 'name.of.model' }
    let(:project) { 'project.id' }
    let(:prediction_settings) do
      double(
        'google_prediction',
        model: model,
        project: project
     )
    end
    let(:text) { 'This is great' }
    let(:scores) do
      {
        'positive' => 0.87,
        'neutral'  => 0.21,
        'negative' => 0.02,
      }
    end

    let(:output_multi) do
      scores.map { |k, v| {'label' => k, 'score' => v} }
    end

    let(:prediction_url) do
      "https://www.googleapis.com/prediction/v1.6/trainedmodels/#{model}/predict"
    end
    let(:prediction_result) do
      {
        'kind'        => 'prediction#output',
        'id'          => 'sample.sentiment',
        'selfLink'    => prediction_url,
        'outputLabel' => 'positive',
        'outputMulti' => output_multi
      }
    end
    let(:body) { prediction_result.to_json }

    let(:execute_result) { double('ApiCLient::Result', body: body) }
    let(:result) { double('MachineClassifier::Result') }

    before do
      api_client.stub(:discovered_api).and_return(prediction_resource)
      client_authorization.stub(:access_token).with().and_return(nil)
      api_client.stub(:authorization=)
      api_client.stub(:execute).and_return(execute_result)
      allow(MachineClassifier::Result).to receive(:new).with(prediction_result).and_return(result)
    end

    before do
      @result = subject.call(text)
    end

    it 'requests authorization' do
      expect(authorizer).to have_received(:authorize).with()
    end

    it 'sets client authorization' do
      expect(api_client).to have_received(:authorization=).with(authorization)
    end

    it 'loads the prediction API' do
      expect(api_client).to have_received(:discovered_api).with('prediction', 'v1.6')
    end

    it 'loads the predict resource' do
      expect(prediction_resource).to have_received(:trainedmodels).with()
      expect(prediction_resource.trainedmodels).to have_received(:predict).with()
    end

    it 'calls the API' do
      expected_body = {input: {csvInstance: [text]}}.to_json
      expected_args = {
        api_method: predict,
        parameters: {'id' => model, 'project' => project},
        body:       expected_body,
        headers:    {'Content-Type' => 'application/json'},
      }
      expect(api_client).to have_received(:execute).with(expected_args)
    end

    it 'initializes a PredictionResult' do
      expect(MachineClassifier::Result).to have_received(:new).with(prediction_result)
    end

    it 'returns the PredictionResult' do
      expect(@result).to eq(result)
    end
  end
end

