describe Nanoc::Int::IdentifiableCollection do
  subject(:identifiable_collection) { described_class.new(config, objects) }

  let(:config) { Nanoc::Int::Configuration.new }
  let(:objects) { [] }

  describe '#reject' do
    subject { identifiable_collection.reject { |_| false } }

    it { is_expected.to be_a(described_class) }
  end

  describe '#find_all' do
    let(:objects) do
      [
        double(:identifiable, identifier: Nanoc::Identifier.new('/about.css')),
        double(:identifiable, identifier: Nanoc::Identifier.new('/about.md')),
        double(:identifiable, identifier: Nanoc::Identifier.new('/style.css')),
      ]
    end

    let(:arg) { raise 'override me' }

    subject { identifiable_collection.find_all(arg) }

    context 'with string' do
      let(:arg) { '/*.css' }

      it 'contains objects' do
        expect(subject.size).to eql(2)
        expect(subject.find { |iv| iv.identifier == '/about.css' }).to eq(objects[0])
        expect(subject.find { |iv| iv.identifier == '/style.css' }).to eq(objects[2])
      end
    end

    context 'with regex' do
      let(:arg) { %r{\.css\z} }

      it 'contains objects' do
        expect(subject.size).to eql(2)
        expect(subject.find { |iv| iv.identifier == '/about.css' }).to eq(objects[0])
        expect(subject.find { |iv| iv.identifier == '/style.css' }).to eq(objects[2])
      end
    end
  end

  describe '#object_with_identifier' do
    let(:objects) do
      [
        Nanoc::Int::Item.new('stuff', {}, Nanoc::Identifier.new('/about.css')),
        Nanoc::Int::Item.new('stuff', {}, Nanoc::Identifier.new('/about.md')),
        Nanoc::Int::Item.new('stuff', {}, Nanoc::Identifier.new('/style.css')),
      ]
    end

    let(:arg) { raise 'override me' }

    subject { identifiable_collection.object_with_identifier(arg) }

    context 'with string' do
      let(:arg) { '/about.css' }
      it { is_expected.to eq(objects[0]) }
    end

    context 'with identifier' do
      let(:arg) { Nanoc::Identifier.new('/about.css') }
      it { is_expected.to eq(objects[0]) }
    end

    context 'with glob string' do
      let(:arg) { '/about.*' }
      it { is_expected.to be_nil }
    end
  end
end
