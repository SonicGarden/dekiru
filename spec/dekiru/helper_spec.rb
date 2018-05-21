require "spec_helper"

describe Dekiru::Helper do
  let(:helper) do
    class AClass
      include Dekiru::Helper
      include ActionView::Helpers::TagHelper
      include ActionView::Context
      include ActionView::Helpers::UrlHelper
    end
    a = AClass.new
  end
  describe "#menu_link_to" do
    before do
      allow(helper).to receive(:current_page?).and_return(true)
    end
    context "一番シンプルな呼び出し" do
      it "動くこと" do
        expect(helper.menu_link_to("テキスト", "/some_path")).to eq("<li class=\"active\"><a href=\"/some_path\">テキスト</a></li>")
      end
    end
    context "blockなし" do
      it "動くこと" do
        expect(helper.menu_link_to("テキスト", "/some_path", class: "some_class")).to eq("<li class=\"active\"><a class=\"some_class\" href=\"/some_path\">テキスト</a></li>")
      end
    end
    context "blockあり" do
      it "動くこと" do
        html = helper.menu_link_to("/some_path", class: "some_class") do
          "テキスト"
        end
        expect(html).to eq("<li class=\"active\"><a class=\"some_class\" href=\"/some_path\">テキスト</a></li>")
      end
    end
    context "今のページじゃない" do
      before do
        allow(helper).to receive(:current_page?).and_return(false)
      end
      it "動くこと" do
        expect(helper.menu_link_to("テキスト", "/some_path", class: "some_class")).to eq("<li class=\"\"><a class=\"some_class\" href=\"/some_path\">テキスト</a></li>")
      end
    end
    context "li_class指定あり" do
      it "動くこと" do
        expect(helper.menu_link_to("テキスト", "/some_path", class: "some_class", li_class: "li_class")).to eq("<li class=\"li_class active\"><a class=\"some_class\" href=\"/some_path\">テキスト</a></li>")
      end
    end
  end
end
