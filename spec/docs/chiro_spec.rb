require 'spec_helper'

describe 'Chiro' do
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

  def endpoint_doc
    Sinatra::Chiro.class_variable_get('@@documentation').first
  end

  context '#endpoint' do
    it 'gives a brief description' do
      subject.endpoint('People greeter') {}
      endpoint_doc.description.should == 'People greeter'
    end
  end

  context '#named_param' do
    it 'documents with defaults' do
      subject.endpoint do
        subject.named_param(:greeting, 'How you want to be greeted')
      end
      n_param = endpoint_doc.named_params[0]

      n_param[:name].should == :greeting
      n_param[:description].should == 'How you want to be greeted'
      n_param[:type].should == String
      n_param[:optional].should be_false
      n_param[:default].should be_nil
    end

    it 'documents with values' do
      subject.endpoint do
        subject.named_param(:people, 'The number of people to be greeted', :type => Fixnum, :default => 1)
      end
      n_param = endpoint_doc.named_params[0]

      n_param[:name].should == :people
      n_param[:description].should == 'The number of people to be greeted'
      n_param[:type].should == Fixnum
      n_param[:optional].should be_false
      n_param[:default].should == 1
    end
  end

  context '#query_param' do
    it 'documents with defaults' do
      subject.endpoint do
        subject.query_param(:greeting, 'How you want to be greeted')
      end
      q_param = endpoint_doc.query_params[0]

      q_param[:name].should == :greeting
      q_param[:description].should == 'How you want to be greeted'
      q_param[:type].should == String
      q_param[:optional].should be_true
      q_param[:default].should be_nil
    end

    it 'documents with values' do
      subject.endpoint do
        subject.query_param(:people, 'The number of people to be greeted', :type => Fixnum, :default => 1, :optional => true)
      end
      q_param = endpoint_doc.query_params[0]

      q_param[:name].should == :people
      q_param[:description].should == 'The number of people to be greeted'
      q_param[:type].should == Fixnum
      q_param[:optional].should be_true
      q_param[:default].should == 1
    end
  end

  context '#returns' do
    it 'gives examples of what might be returned' do
      subject.endpoint('People greeter') do
        subject.returns('e.g. Hello world')
      end
      endpoint_doc.returns.should == 'e.g. Hello world'
    end
  end
end