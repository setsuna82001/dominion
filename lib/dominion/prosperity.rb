# coding: utf-8
class Prosperity < DominionLib
  
  ColonyNumber    = 115  #植民地
  PlatinumNumber  = 122  #白金貨
  
  def initialize( card, series_num )
    super(  card, series_num,
        { :relate => [ ColonyNumber, PlatinumNumber ] }
    )
  end
  
  def get_relate_supply( mainlist = nil )
    ret       = Array.new
    self_list = mainlist.select{| id | @card_list[ id ][ :series ] == @series_num }
    ret << ColonyNumber    if ( rand( mainlist.size ) + 1 ) <= self_list.size
    ret << PlatinumNumber  if ( rand( mainlist.size ) + 1 ) <= self_list.size
    return ret
  end

end