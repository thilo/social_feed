class Object
  def try(method, *params)
    send method, *params if respond_to? method
  end
end

class Object
  def if_nil?
    self
  end
  
  def if_not_nil?
    yield self
  end
end

class NilClass
  def if_nil?
    yield self
    self
  end
  
  def if_not_nil?
    self
  end
end

