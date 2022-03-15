RSpec.describe Sfdc::Core do
  let(:client) { instance_double("restforce client") }
  let(:config) { instance_double("config") }
  let(:logger) { instance_spy(Logger) }

  before do
    allow(described_class).to receive(:client).and_return(client)
    allow(described_class).to receive(:config).and_return(config)
    allow(config).to receive(:logger).and_return(logger)
  end

  describe ".find" do
    subject { described_class.find(object_name, id) }

    let(:object_name) { "ObjectName" }

    context "ID未指定" do
      let(:id) { nil }

      it "エラーが発生する" do
        expect { subject }.to raise_error(Sfdc::Core::RecordNotFound, "Couldn't find ")
      end
    end

    context "存在しないID" do
      let(:id) { "notfound" }

      before do
        allow(client).to receive(:find).with(object_name, id).and_raise(Restforce::NotFoundError, "ERROR")
      end

      it "エラーが発生する" do
        expect { subject }.to raise_error(Sfdc::Core::RecordNotFound, "Couldn't find #{id}")
      end
    end

    context "存在するID" do
      let(:id) { "found" }
      let(:record) { instance_double("restforce result", attrs: attrs) }
      let(:attrs) { { Id: "test" } }

      before do
        allow(client).to receive(:find).with(object_name, id).and_return(record)
      end

      it "値が取得できる" do
        expect(subject).to eq(attrs)
      end
    end
  end

  describe ".find_by" do
    subject { described_class.find_by(object_name, args) }

    let(:object_name) { "ObjectName" }
    let(:args) { { key1: "key1", key2: nil, key3: :key3 } }
    let(:record) { instance_double("restforce result", Id: "id1") }
    let(:records) { [record, instance_double("restforce result", Id: "id2")] }
    let(:attrs) { { Id: "id1" } }

    before do
      allow(client).to receive(:query)
        .with("select Id from #{object_name} where key1 = 'key1' AND key2 = null AND key3 = key3")
        .and_return(records)
    end

    context "存在するID" do
      before do
        allow(described_class).to receive(:find).with(object_name, attrs[:Id]).and_return(attrs)
      end

      it "値が取得できる" do
        expect(subject).to eq(attrs)
      end
    end

    context "存在しないID" do
      before do
        allow(described_class).to receive(:find).with(object_name, attrs[:Id]).and_raise(Sfdc::Core::RecordNotFound)
      end

      it "値が取得できない" do
        expect(subject).to be_nil
      end
    end
  end

  describe ".last" do
    subject { described_class.last(object_name) }

    let(:object_name) { "ObjectName" }
    let(:record) { instance_double("restforce result", Id: "id1") }
    let(:records) { [record, instance_double("restforce result", Id: "id2")] }
    let(:attrs) { { Id: "id1" } }

    before do
      allow(client).to receive(:query)
        .with("select Id from #{object_name} order by Id desc limit 1")
        .and_return(records)
    end

    context "存在するID" do
      before do
        allow(described_class).to receive(:find).with(object_name, attrs[:Id]).and_return(attrs)
      end

      it "値が取得できる" do
        expect(subject).to eq(attrs)
      end
    end

    context "存在しないID" do
      before do
        allow(described_class).to receive(:find).with(object_name, attrs[:Id]).and_raise(Sfdc::Core::RecordNotFound)
      end

      it "値が取得できない" do
        expect(subject).to be_nil
      end
    end
  end

  describe ".create!" do
    subject { described_class.create!(object_name, params) }

    let(:object_name) { "ObjectName" }
    let(:params) { { Attribute__c: "test" } }

    context "オブジェクト名が未指定の場合" do
      let(:object_name) { nil }

      it "エラーが発生する" do
        expect { subject }.to raise_error(Sfdc::Core::ArgumentError, "wrong number of arguments")
      end
    end

    context "パラメータが未指定の場合" do
      let(:params) { nil }

      it "エラーが発生する" do
        expect { subject }.to raise_error(Sfdc::Core::ArgumentError, "wrong number of arguments")
      end
    end

    context "作成成功" do
      let(:id) { "id1" }
      let(:attrs) { { Id: "id1" } }

      before do
        allow(client).to receive(:create!).with(object_name, params).and_return(id)
        allow(described_class).to receive(:find).with(object_name, id).and_return(attrs)
      end

      it "作成したオブジェクトを返却する" do
        expect(subject).to eq(attrs)
      end
    end

    context "作成失敗" do
      let(:id) { "id1" }
      let(:attrs) { { Id: "id1" } }

      before do
        allow(client).to receive(:create!).with(object_name, params)
          .and_raise(Restforce::ResponseError.new("ERROR",
                                                  { body: [
                                                    { "message" => "ERROR1" }, { "message" => "ERROR2" }
                                                  ] }))
      end

      it "エラーが発生する" do
        expect { subject }.to raise_error(Sfdc::Core::RecordInvalid, "ERROR1 ERROR2")
        expect(logger).to have_received(:error).with({ "message" => "ERROR1" }).once
        expect(logger).to have_received(:error).with({ "message" => "ERROR2" }).once
      end
    end
  end

  describe ".update!" do
    subject { described_class.update!(object_name, id, params) }

    let(:object_name) { "ObjectName" }
    let(:id) { "id" }
    let(:params) { { Attribute__c: "test" } }

    context "オブジェクト名が未指定の場合" do
      let(:object_name) { nil }

      it "エラーが発生する" do
        expect { subject }.to raise_error(Sfdc::Core::ArgumentError, "wrong number of arguments")
      end
    end

    context "idが未指定の場合" do
      let(:id) { nil }

      it "エラーが発生する" do
        expect { subject }.to raise_error(Sfdc::Core::ArgumentError, "wrong number of arguments")
      end
    end

    context "パラメータが未指定の場合" do
      let(:params) { nil }

      it "エラーが発生する" do
        expect { subject }.to raise_error(Sfdc::Core::ArgumentError, "wrong number of arguments")
      end
    end

    context "更新成功" do
      let(:attrs) { { Id: "id1" } }

      before do
        allow(client).to receive(:update!).with(object_name, { Id: id }.merge(params))
        allow(described_class).to receive(:find).with(object_name, id).and_return(attrs)
      end

      it "更新したオブジェクトを返却する" do
        expect(subject).to eq(attrs)
      end
    end

    context "作成失敗" do
      let(:id) { "id1" }
      let(:attrs) { { Id: "id1" } }

      before do
        allow(client).to receive(:update!).with(object_name, { Id: id }.merge(params))
          .and_raise(Restforce::ResponseError.new("ERROR",
                                                  { body: [
                                                    { "message" => "ERROR1" }, { "message" => "ERROR2" }
                                                  ] }))
      end

      it "エラーが発生する" do
        expect { subject }.to raise_error(Sfdc::Core::RecordInvalid, "ERROR1 ERROR2")
        expect(logger).to have_received(:error).with({ "message" => "ERROR1" }).once
        expect(logger).to have_received(:error).with({ "message" => "ERROR2" }).once
      end
    end
  end

  describe ".client" do
    subject { described_class.client }

    before do
      allow(described_class).to receive(:client).and_call_original
    end

    it "SFDC接続用クライアントを返却する" do
      expect(subject).to be_kind_of(Restforce::Data::Client)
    end
  end

  describe ".config" do
    subject { described_class.config }

    before do
      allow(described_class).to receive(:config).and_call_original
    end

    it "設定情報を返却する" do
      expect(subject.logger).to be_kind_of(Logger)
    end
  end
end
