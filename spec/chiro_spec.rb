require 'spec_helper'

describe 'Chiro Documentation' do
  before do
    Sinatra::Chiro.class_variable_set('@@documentation', [])
  end

  after(:all) do
    Sinatra::Chiro.class_variable_set('@@documentation', [])
  end

  subject do
    Class.new(Sinatra::Base) do
      register Sinatra::Chiro
    end
  end

  it 'documents url parameters' do
    subject.endpoint do
      subject.named_param(:greeting, String, 'How you want to be greeted')
    end
    n_param = endpoint_doc.named_params[0]

    n_param[:name].should == :greeting
    n_param[:type].should == String
    n_param[:description].should == 'How you want to be greeted'
  end

  it 'documents query_param parameters' do
    subject.endpoint do
      subject.query_param(:greeting, String, 'How you want to be greeted')
    end
    q_param = endpoint_doc.query_params[0]

    q_param[:name].should == :greeting
    q_param[:type].should == String
    q_param[:description].should == 'How you want to be greeted'
  end

  def endpoint_doc
    Sinatra::Chiro.class_variable_get('@@documentation').first
  end
end