module MachineClassifier
  class Result < Struct.new(:data)
    def winner
      data['outputLabel']
    end

    def success?
      data['kind'] == 'prediction#output'
    end

    def error?
      data.include?('error')
    end
  end
end

