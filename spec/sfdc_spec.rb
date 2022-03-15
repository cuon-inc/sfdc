RSpec.describe Sfdc do
  it "has a version number" do
    expect(Sfdc::VERSION).not_to be nil
  end

  describe ".config" do
    subject { described_class.config }

    context "初期値" do
      it "初期設定されたロガーを返却する" do
        expect(subject.logger).to be_kind_of(Logger)
      end
    end

    context "設定後" do
      let(:any_logger) { instance_double("any logger") }

      before do
        described_class.configure do |config|
          config.logger = any_logger
        end
      end

      after do
        described_class.configure do |config|
          config.logger = Logger.new($stdout)
        end
      end

      it "設定されたロガーを返却する" do
        expect(subject.logger).to eq(any_logger)
      end
    end
  end
end
