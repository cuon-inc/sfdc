RSpec.describe Sfdc::Account do
  describe ".find" do
    subject { described_class.find(id) }

    after { Sfdc::Core.instance_variable_set(:@client, nil) }

    context "存在するデータのparams" do
      let(:id) { "001O0000023ehogehoge" }

      let(:response) do
        { "Id" => "001O0000023ehogehoge",
          "IsDeleted" => false,
          "MasterRecordId" => nil,
          "Name" => "テストアカウント",
          "Type" => "顧客",
          "ParentId" => nil,
          "BillingStreet" => "hogehogeビル 4階",
          "BillingCity" => "天神hogehoge",
          "BillingState" => "福岡県",
          "BillingPostalCode" => "8100001",
          "BillingCountry" => nil,
          "BillingLatitude" => nil,
          "BillingLongitude" => nil,
          "BillingGeocodeAccuracy" => nil,
          "BillingAddress" => { "city" => "天神hogehoge", "country" => nil, "geocodeAccuracy" => nil,
                                "latitude" => nil, "longitude" => nil, "postalCode" => "8100001",
                                "state" => "福岡県", "street" => "hogehogeビル 4階" },
          "ShippingStreet" => nil,
          "ShippingCity" => nil,
          "ShippingState" => nil,
          "ShippingPostalCode" => nil,
          "ShippingCountry" => nil,
          "ShippingLatitude" => nil,
          "ShippingLongitude" => nil,
          "ShippingGeocodeAccuracy" => nil,
          "ShippingAddress" => nil,
          "Phone" => "090000000",
          "Fax" => nil,
          "AccountNumber" => nil,
          "Website" => nil,
          "PhotoUrl" => nil,
          "Sic" => nil,
          "Industry" => nil,
          "AnnualRevenue" => nil,
          "NumberOfEmployees" => nil,
          "Ownership" => nil,
          "TickerSymbol" => nil,
          "Description" => nil,
          "Rating" => nil,
          "Site" => nil,
          "OwnerId" => "0050T000001R35HOGE",
          "CreatedDate" => "2022-01-14T01:14:40.000+0000",
          "CreatedById" => "0050T000001R35WQAS",
          "LastModifiedDate" => "2022-01-14T01:14:47.000+0000",
          "LastModifiedById" => "0050T000001R35HOGE",
          "SystemModstamp" => "2022-01-14T01:14:47.000+0000",
          "LastActivityDate" => nil,
          "LastViewedDate" => "2022-01-14T01:14:47.000+0000",
          "LastReferencedDate" => "2022-01-14T01:14:47.000+0000",
          "IsPartner" => false,
          "Jigsaw" => nil,
          "JigsawCompanyId" => nil,
          "AccountSource" => nil,
          "SicDesc" => nil,
          "Field1__c" => "test.com99",
          "DUNS_Number__c" => nil,
          "Yubizo_Developer_Program_ID__c" => nil,
          "CLOMOdomain__c" => "test.com99" }
      end

      before do
        client = double(Restforce) # rubocop:disable RSpec/VerifiedDoubles
        allow(Restforce).to receive(:new).and_return(client)
        allow(client).to receive(:find).and_return(client)
        allow(client).to receive(:attrs).and_return(response)
        allow(described_class).to receive(:object_name).and_return("Account")
      end

      it "レコードが取得できること" do
        res = subject
        expect(res["Id"]).to eq "001O0000023ehogehoge"
        expect(res["Name"]).to eq "テストアカウント"
        expect(res["Type"]).to eq "顧客"
      end
    end

    context "存在しないデータのid" do
      let(:id) { "hogehoge" }

      before do
        client = double(Restforce) # rubocop:disable RSpec/VerifiedDoubles
        allow(Restforce).to receive(:new).and_return(client)
        allow(client).to receive(:find).and_return(client)
        allow(client).to receive(:attrs).and_raise(Restforce::NotFoundError.new({}))
        allow(described_class).to receive(:object_name).and_return("Account")
      end

      it "エラーが返ること" do
        expect { subject }.to raise_error(Sfdc::Core::RecordNotFound)
      end
    end
  end
end
