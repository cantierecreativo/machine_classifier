require 'google/api_client'

module MachineClassifier
  class Client < Struct.new(:configuration)
    HEADERS = {'Content-Type' => 'application/json'}

    def call(text)
      authorize!

      predict       = prediction_api.trainedmodels.predict
      body          = {input: {csvInstance: [text]}}.to_json

      result = api_client.execute(
        api_method: predict,
        parameters: {'id' => model_id, 'project' => project_id},
        body:       body,
        headers:    HEADERS
      )
      data = JSON.parse(result.body)
      Result.new(data)
    end

    def categories
      output = metadata['dataDescription']['outputFeature']['text']
      output.map { |category| category['value'] }
    end

    def confusion
      metadata['modelDescription']['confusionMatrix']
    end

    def metadata
      return @metadata if @metadata

      authorize!

      analyze = prediction_api.trainedmodels.analyze

      result = api_client.execute(
        api_method: analyze,
        parameters: {'id' => model_id, 'project' => project_id},
        headers:    HEADERS
      )
      @metadata = JSON.parse(result.body)
    end

    private

    def authorize!
      return unless api_client.authorization.access_token.nil?
      api_client.authorization = authorizer.authorize
    end

    def prediction_api
      api_client.discovered_api('prediction', configuration.api_version)
    end

    def authorizer
      @authorizer ||= MachineClassifier::Authorizer.new(configuration)
    end

    def api_client
      @api_client ||= Google::APIClient.new(
        application_name: configuration.application_name,
        application_version: configuration.application_version,
      )
    end

    def project_id
      configuration.project
    end

    def model_id
      configuration.model
    end
  end
end

