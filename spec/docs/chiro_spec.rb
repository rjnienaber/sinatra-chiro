require 'spec_helper'

describe 'Chiro' do
  subject do
    Class.new(Sinatra::Base) do
      register Sinatra::Chiro
    end
  end

  def endpoint_doc
    subject.documentation.first
  end

  context '#endpoint' do
    it 'gives a brief description with defaults' do
      subject.endpoint('People greeter') {}
      endpoint_doc.description.should == 'People greeter'
      endpoint_doc.validate?.should be_true
      endpoint_doc.verb.should == :GET
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

  context '#form' do
    it 'documents with defaults' do
      subject.endpoint do
        subject.form(:greeting, 'How you want to be greeted')
      end
      form = endpoint_doc.forms[0]

      form[:name].should == :greeting
      form[:description].should == 'How you want to be greeted'
      form[:type].should == String
      form[:optional].should be_true
      form[:default].should be_nil
    end

    it 'documents with values' do
      subject.endpoint do
        subject.form(:people, 'The number of people to be greeted', :type => Fixnum, :default => 1, :optional => true)
      end
      form = endpoint_doc.forms[0]

      form[:name].should == :people
      form[:description].should == 'The number of people to be greeted'
      form[:type].should == Fixnum
      form[:optional].should be_true
      form[:default].should == 1
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