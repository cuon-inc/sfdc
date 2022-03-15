RSpec.describe Sfdc::Base do
  let(:object_name) { "Base" }

  describe ".object_name" do
    subject { described_class.object_name }

    it "最下位の名前空間を返却する" do
      expect(subject).to eq("Base")
    end
  end

  describe ".find" do
    subject { described_class.find(id) }

    let(:id) { "id" }

    before do
      allow(Sfdc::Core).to receive(:find)
    end

    it "コア機能の.findを呼び出す" do
      subject
      expect(Sfdc::Core).to have_received(:find).with(object_name, id)
    end
  end

  describe ".find_by" do
    subject { described_class.find_by(args) }

    let(:args) { { key1: "key1", key2: nil, key3: :key3 } }

    before do
      allow(Sfdc::Core).to receive(:find_by)
    end

    it "コア機能の.find_byを呼び出す" do
      subject
      expect(Sfdc::Core).to have_received(:find_by).with(object_name, args)
    end
  end

  describe ".last" do
    subject { described_class.last }

    before do
      allow(Sfdc::Core).to receive(:last)
    end

    it "コア機能の.lastを呼び出す" do
      subject
      expect(Sfdc::Core).to have_received(:last)
    end
  end

  describe ".create!" do
    subject { described_class.create!(params) }

    let(:params) { { Attribute__c: "test" } }

    before do
      allow(Sfdc::Core).to receive(:create!)
    end

    it "コア機能の.create!を呼び出す" do
      subject
      expect(Sfdc::Core).to have_received(:create!).with(object_name, params)
    end
  end

  describe ".update!" do
    subject { described_class.update!(id, params) }

    let(:id) { "id" }
    let(:params) { { Attribute__c: "test" } }

    before do
      allow(Sfdc::Core).to receive(:update!)
    end

    it "コア機能の.update!を呼び出す" do
      subject
      expect(Sfdc::Core).to have_received(:update!).with(object_name, id, params)
    end
  end
end
