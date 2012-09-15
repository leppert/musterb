describe Musterb::Evaluator do
  it "can pull local variables out from the binding" do
    foo = "bar"
    evaluator = Musterb::Evaluator.new Musterb::BindingExtractor.new(binding)
    evaluator["foo"].should eq "bar"
  end

  it "pulls out values from ." do
    evaluator = Musterb::Evaluator.new Musterb::ObjectExtractor.new(2, nil)
    evaluator["."].should eq 2
  end

  it "can do nested values" do
    evaluator = Musterb::Evaluator.new Musterb::ObjectExtractor.new(2, nil)
    evaluator["next.to_s"].should eq "3"
  end

  it "does not barf when pulling out a value on nil" do
    evaluator = Musterb::Evaluator.new Musterb::HashExtractor.new({:foo => nil}, nil)
    evaluator["foo.bar"].should eq nil
  end

  context "block" do
    it "yields to the block if a value is set" do    
      foo = "bar"
      evaluator = Musterb::Evaluator.new Musterb::BindingExtractor.new(binding)
      expect { |b| evaluator.block("foo", &b) }.to yield_control
    end

    it "does not yield to the block if the value is unset" do
      foo = nil
      evaluator = Musterb::Evaluator.new Musterb::BindingExtractor.new(binding)
      expect { |b| evaluator.block("foo", &b) }.not_to yield_control
    end

    it "yields to the block for every element in the array" do
      foo = [1, 2, 3]
      evaluator = Musterb::Evaluator.new Musterb::BindingExtractor.new(binding)
      expect { |b| evaluator.block("foo", &b) }.to yield_successive_args(1,2,3)
    end

    it "does not yield to an empty array" do
      foo = []
      evaluator = Musterb::Evaluator.new Musterb::BindingExtractor.new(binding)
      expect { |b| evaluator.block("foo", &b) }.not_to yield_control
    end

    it "yields to an empty hash" do
      foo = {}
      evaluator = Musterb::Evaluator.new Musterb::BindingExtractor.new(binding)
      expect { |b| evaluator.block("foo", &b) }.to yield_control
    end
  end

  context "block_unless" do
    it "does not yield to the block if a value is set" do    
      foo = "bar"
      evaluator = Musterb::Evaluator.new Musterb::BindingExtractor.new(binding)
      expect { |b| evaluator.block_unless("foo", &b) }.not_to yield_control
    end

    it "does not yield to the block if the value is unset" do
      foo = nil
      evaluator = Musterb::Evaluator.new Musterb::BindingExtractor.new(binding)
      expect { |b| evaluator.block_unless("foo", &b) }.to yield_control
    end

    it "yields to the block for every element in the array" do
      foo = [1, 2, 3]
      evaluator = Musterb::Evaluator.new Musterb::BindingExtractor.new(binding)
      expect { |b| evaluator.block_unless("foo", &b) }.not_to yield_control
    end

    it "does not yield to an empty array" do
      foo = []
      evaluator = Musterb::Evaluator.new Musterb::BindingExtractor.new(binding)
      expect { |b| evaluator.block_unless("foo", &b) }.to yield_control
    end
  end

  context "switching context" do
    it "switches inside a hash" do
      hash = { "foo" => "bar"}    
      evaluator = Musterb::Evaluator.new Musterb::BindingExtractor.new(binding)
      evaluator.block "hash" do
        evaluator['foo'].should eq 'bar'
      end
    end

    it "resets the context later" do
      hash = { "foo" => "bar"}
      evaluator = Musterb::Evaluator.new Musterb::BindingExtractor.new(binding)
      evaluator.block("hash") {}
      evaluator["hash"].should eq hash
    end

    it "cascades the context to the parent" do
      foo = "bar"
      hash = { }
      evaluator = Musterb::Evaluator.new Musterb::BindingExtractor.new(binding)
      evaluator.block "hash" do
        evaluator['foo'].should eq 'bar'
      end
    end
  end
end