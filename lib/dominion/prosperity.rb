# coding: utf-8
class Prosperity < DominionLib
  #module
  module Moduler
    ColonyNumber    = 115  #植民地
    PlatinumNumber  = 122  #白金貨
  end
  
  def initialize( card, series_num )
    super(  card, series_num,
        { :relate => [ Moduler::ColonyNumber, Moduler::PlatinumNumber ] }
    )
  end
  
  def get_relate_supply( mainlist = nil )
    ret       = Array.new
    self_list = mainlist.select{| id | @card_list[ id ][ :series ] == @series_num }
    ret << Moduler::ColonyNumber    if ( rand( mainlist.size ) + 1 ) <= self_list.size
    ret << Moduler::PlatinumNumber  if ( rand( mainlist.size ) + 1 ) <= self_list.size
    return ret
  end

end