require 'spec_helper'

describe MachineClassifier::Result do
  let(:data) do
    {
      'outputLabel' => 'foo',
      'outputMulti' => [
        {'label' => 'foo', 'score' => '0.4',},
        {'label' => 'bar', 'score' => '0.3',},
        {'label' => 'baz', 'score' => '0.3',},
      ]
    }
  end

  subject { MachineClassifier::Result.new(data) }

  describe '#initialize' do
    it 'expects a data parameter' do
      expect(subject.data).to eq(data)
    end
  end

  describe '#winner' do
    it 'returns top category' do
      expect(subject.winner).to eq('foo')
    end
  end

  describe '#success?' do
    it 'is false' do
      expect(subject.success?).to be_false
    end
  end

  describe '#error?' do
    it 'is false' do
      expect(subject.error?).to be_false
    end
  end
end

