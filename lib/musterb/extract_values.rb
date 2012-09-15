module ExtractValues
  def value
    @context.value
  end

  def [](symbol)
    @context[symbol]
  end

  def chain(symbol)
    Musterb::Chain.new self[symbol]
  end

  private
  def new_context(value, old_context = @context)
    case value
    when Hash
      Musterb::HashExtractor.new(value, old_context)
    when nil
      Musterb::NullExtractor.new(old_context)
    else
      Musterb::ObjectExtractor.new(value, old_context)
    end
  end
end