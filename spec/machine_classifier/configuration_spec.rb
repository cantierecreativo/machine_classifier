require 'spec_helper'

describe MachineClassifier::Configuration do
  describe '#initialize' do
    it 'calls a supplied block' do
      calls = 0
      described_class.new { |config| calls += 1 }
      expect(calls).to eq(1)
    end

    it 'passes itself to a block' do
      config = described_class.new { |config| config.application_name = 'AAAA' }
      expect(config.application_name).to eq('AAAA')
    end

    specify 'the block is optional' do
      expect { described_class.new }.to_not raise_error
    end
  end

  describe '#valid?' do
    subject do
      described_class.new do |conf|
        conf.api_version = 'api_version'
        conf.application_name = 'application_name'
        conf.application_version = 'application_version'
        conf.developer_email = 'developer_email'
        conf.model = 'model'
        conf.private_key = 'private_key'
        conf.private_key_password = 'private_key_password'
        conf.project = 'project'
      end
    end

    context 'with all values set' do
      it 'is true' do
        expect(subject.valid?).to be_true
      end
    end

    %w(application_name application_version).each do |attribute|
      context "with #{attribute} missing" do
        it "is false" do
          method = "#{attribute}=".intern
          subject.send(method, nil)
          expect(subject.valid?).to be_false
        end
      end
    end
  end
end
