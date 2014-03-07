# coding: utf-8
class Cornucopia < DominionLib
  
  YoungWitchNumber            = 142  #魔女娘
  YoungWitchExtractCostMin    = 2
  YoungWitchExtractCostMax    = 3
  YoungWitchExtractCostRange  = ( YoungWitchExtractCostMin .. YoungWitchExtractCostMax ).to_a
  
  TournamentNumber    = 139  #馬上槍試合
  DiademNumber        = 130  
  PrincessNumber      = 131  
  BagOfGoldNumber     = 132  
  TrustySteedNumber   = 143  
  FollowersNumber     = 144  
  Decorations         = [ DiademNumber, PrincessNumber, BagOfGoldNumber, TrustySteedNumber, FollowersNumber ]
  
  CardRelations       = {
    TournamentNumber  => Decorations
  }
  
  def initialize( card, series_num )
    super( card, series_num,
        { :relate => Decorations }
    )
  end
  
  def get_relate_supply( mainlist = nil )
    ret      = Array.new
    mainlist.each{| id |
      unless CardRelations[ id ].nil?
        ret += CardRelations[ id ]
      end
    }
    return ret
  end
  
  def get_option_supply( obj = nil )
    ret      = Array.new
    series    = obj[ :select_series ].keys
    if obj[ :mainlist ].include?( YoungWitchNumber )
      select  = @card_list.select{| key, vol |
        obj[ :mainlist ].include?( key ).!  &&          # non exist in mainlist
        series.include?( vol[:series] )    &&          # selectable series
        YoungWitchExtractCostRange.include?( vol[:cost].to_i )  # const in range
      }
      ret << select.to_a.sample[0] unless select.empty?
    end
    return ret
  end
end