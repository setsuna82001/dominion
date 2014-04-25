# coding: utf-8
class Base < DominionLib
  #module
  module Moduler
    BaseRelateList  = [ *1 .. 7 ]
  end
  
  def initialize( card, series_num )

    super(  card, series_num,
      { :delete => Moduler::BaseRelateList }
    )
  end
  
end