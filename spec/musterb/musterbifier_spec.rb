describe Musterb::Musterbifier do
  it "does not change vanilla strings" do
    Musterb::Musterbifier.new("Hello, world!").to_erb.should eq "Hello, world!"
  end

  it "replaces mustaches correctly" do
    Musterb::Musterbifier.new("Hello, {{world}}!").to_erb.should eq "Hello, <%== musterb['world'] %>!"
  end

  it "replaces triple staches correctly" do
    Musterb::Musterbifier.new("Hello, {{{world}}}!").to_erb.should eq "Hello, <%= musterb['world'] %>!"
  end

  it "does not escape if it starts with &" do
    Musterb::Musterbifier.new("Hello, {{& world}}!").to_erb.should eq "Hello, <%= musterb['world'] %>!"
  end

  it "replaces blocks correctly" do
    Musterb::Musterbifier.new("{{#cond}}foo{{/cond}}").to_erb.should eq "<% musterb.block 'cond' do %>foo<% end %>"
  end

  it "replaces carrot correctly" do
    Musterb::Musterbifier.new("{{^cond}}foo{{/cond}}").to_erb.should eq "<% musterb.block_unless 'cond' do %>foo<% end %>"
  end

  it "replaces comments with nothing" do
    Musterb::Musterbifier.new("{{! foo\n bar}}").to_erb.should eq ""
  end

  it "replaces . with current value" do
    Musterb::Musterbifier.new("{{.}}").to_erb.should eq "<%== musterb.current %>"
  end
end