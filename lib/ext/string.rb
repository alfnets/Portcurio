class String
  def to_boolean
    # 関数の呼び出し元文字列がtureだったらBoolean型のtrueを返す
    if self =~ /(true|True|TRUE|1)/
      return true
    # 関数の呼び出し元文字列がfalseだったらBoolean型のfalseを返す
    elsif self =~ /(false|False|FALSE|0)/
      return false
    # 関数の呼び出し元文字列がtrue、false以外だったら元の文字列を返す
    else
      return self
    end
  end
end