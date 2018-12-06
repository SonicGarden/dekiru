require 'spec_helper'

class TestMailer < ActionMailer::Base 
  default from: 'no-reply@dekiru.test'

  def test(to)
    mail to: to, subject: 'test', body: 'test'
  end
end

describe Dekiru::MailSecurityInterceptor do  
  before do
    interceptor = Dekiru::MailSecurityInterceptor.new
    ActionMailer::Base.register_interceptor(interceptor)
  end

  context '宛先（to）が空配列の場合' do 
    let(:to_address) { [] }
    it '例外が発生すること' do 
      expect { TestMailer.test(to_address).deliver_now }.to raise_error(Dekiru::MailSecurityInterceptor::NoToAdreessError)
    end
  end
  context '宛先（to）が空文字の場合' do 
    let(:to_address) { '' }
    it '例外が発生すること' do 
      expect { TestMailer.test(to_address).deliver_now }.to raise_error(Dekiru::MailSecurityInterceptor::NoToAdreessError)
    end
  end
  context '宛先（to）がnilの場合' do 
    let(:to_address) { nil }
    it '例外が発生すること' do 
      expect { TestMailer.test(to_address).deliver_now }.to raise_error(Dekiru::MailSecurityInterceptor::NoToAdreessError)
    end
  end
  context '宛先（to）が文字列の場合' do 
    let(:to_address) { 'test@dekiru.test' }
    it '例外が発生しないこと' do 
      expect { TestMailer.test(to_address).deliver_now }.not_to raise_error
    end
  end
  context '宛先（to）が配列の場合' do
    let(:to_address) { ['test@dekiru.test'] }
    it '例外が発生しないこと' do 
      expect { TestMailer.test(to_address).deliver_now }.not_to raise_error
    end
  end
end
