class Integer
  def to_boolean
    if self == 1
      return true
    elsif self == 0
      return false
    else
      return self
    end
  end
end