# coding: utf-8
class Darkages < DominionLib
  #module
  module Moduler
    
    #Knights
    KnightsNumber       = 178
    SirVanderNumber     = 179
    SirDestryNumber     = 180
    SirBaileyNumber     = 181
    SirMartinNumber     = 182
    SirMichaelNumber    = 183
    DameAnnaNumber      = 184
    DameJosephineNumber = 185
    DameSylviaNumber    = 186
    DameNatalieNumber   = 187
    DameMollyNumber     = 188
    Knights             = [ Moduler::SirVanderNumber,     Moduler::SirDestryNumber,
                            Moduler::SirBaileyNumber,     Moduler::SirMartinNumber, 
                            Moduler::SirMichaelNumber,    Moduler::DameAnnaNumber, 
                            Moduler::DameJosephineNumber, Moduler::DameSylviaNumber, 
                            Moduler::DameNatalieNumber,   Moduler::DameMollyNumber
                          ]
    #Shelters
    NecropolisNumber      = 193  #共同墓地
    OvergrownEstateNumber = 195  #草茂る屋敷
    HovelNumber           = 212  #納屋
    Shelters              = [ Moduler::NecropolisNumber, Moduler::OvergrownEstateNumber, Moduler::HovelNumber ]
    
    #Ruins
    RuinedMarketNumber    = 174  #市場跡地
    SurvivorsNumber       = 207  #生存者
    RuinedLibraryNumber   = 211  #図書館跡地
    AbandonedMineNumber   = 214  #廃坑
    RuinedVillageNumber   = 215  #廃村
    Ruins                 = [ Moduler::RuinedMarketNumber,  Moduler::SurvivorsNumber, 
                              Moduler::RuinedLibraryNumber, Moduler::AbandonedMineNumber, 
                              Moduler::RuinedVillageNumber ]
    DeathCartNumber       = 203  #死の荷車
    CultistNumber         = 192  #狂信者
    
    
    HermitNumber          = 175  #隠遁者
    MadmanNumber          = 191  #狂人

    UrchinNumber          = 221  #浮浪児
    MercenaryNumber       = 226  #傭兵
    
    BanditCampNumber      = 202  #山賊の宿営地
    PillageNumber         = 227  #略奪
    MarauderNumber        = 204  #襲撃者
    SpoilsNumber          = 228  #略奪品
    
    CardRelations         = {
  #   Moduler::KnightsNumber    => Moduler::Knights,
      Moduler::DeathCartNumber  => Moduler::Ruins,
      Moduler::CultistNumber    => Moduler::Ruins,
      Moduler::MarauderNumber   => Moduler::Ruins + [ Moduler::SpoilsNumber ],
      Moduler::HermitNumber     => [ Moduler::MadmanNumber ],
      Moduler::UrchinNumber     => [ Moduler::MercenaryNumber ],
      Moduler::BanditCampNumber => [ Moduler::SpoilsNumber ],
      Moduler::PillageNumber    => [ Moduler::SpoilsNumber ],
    }
  end
  
  def initialize( card, series_num )
    super( card, series_num,
        { :relate => Moduler::Ruins + [ Moduler::MadmanNumber, Moduler::MercenaryNumber, Moduler::SpoilsNumber ],
          :delete => Moduler::Knights,
          :deck   => Moduler::Shelters
        }
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
  
  def get_deck_supply( mainlist = nil )
    ret       = Array.new
    self_list = mainlist.select{| id | @card_list[ id ][ :series ] == @series_num }
    if self_list.size > 0
      ret << Moduler::NecropolisNumber      if ( rand( mainlist.size ) + 1 ) < self_list.size
      ret << Moduler::OvergrownEstateNumber if ( rand( mainlist.size ) + 1 ) < self_list.size
      ret << Moduler::HovelNumber           if ( rand( mainlist.size ) + 1 ) < self_list.size
    end
    return ret
  end
  
end