class Musterb::Evaluator
  def initialize(_binding)
    @context = Musterb::BindingExtractor.new _binding
  end

  def [](symbol)
    @context[symbol]
  end

  def block(symbol)
    value = self[symbol]
    return if is_falsy? value

    case value
    when Hash
      switch_context(value) { |v| yield v }
    when Enumerable
      value.each { |e| switch_context(e) { |v| yield v } }
    else
      switch_context(value) { |v| yield v }
    end
  end

  def block_unless(symbol)
    yield if is_falsy? self[symbol]
  end

  private

  def is_falsy?(value)
    case value
    when Hash
      false
    when Enumerable
      value.empty?
    else
      !value
    end
  end

  def new_context(value)
    HashExtractor.new(value, @context)
  end

  def old_context
    @context.parent
  end

  def switch_context(value)
    @context = new_context(value)
    yield value
    @context = old_context
  end
end