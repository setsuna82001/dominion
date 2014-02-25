# coding: utf-8
class Cornucopia < DominionLib
	
	YoungWitchNumber			= 142	#魔女娘
	YoungWitchExtractCostMin	= 2
	YoungWitchExtractCostMax	= 3
	YoungWitchExtractCostRange	= ( YoungWitchExtractCostMin .. YoungWitchExtractCostMax ).to_a
	
	TournamentNumber			= 139	#馬上槍試合
	
	DiademNumber			= 130	
	PrincessNumber			= 131	
	BagOfGoldNumber			= 132	
	TrustySteedNumber		= 143	
	FollowersNumber			= 144	
	Decorations				= [ DiademNumber, PrincessNumber, BagOfGoldNumber, TrustySteedNumber, FollowersNumber ]
	
	CardRelations			= {
		TournamentNumber	=> Decorations
	}
	
	def initialize( card, series_num )
		super(	card, series_num,
				{ :relate => Decorations }
		)
	end
	
	def get_relate_supply( main_list = nil )
		ret			= Array.new
		main_list.each{| id |
			unless CardRelations[ id ].nil?
				ret += CardRelations[ id ]
			end
		}
		return ret
	end
	
	def get_option_supply( main_list = nil )
		ret			= Array.new
		if main_list.include?( YoungWitchNumber )
			ret << @card_list.select{| key, vol |
				YoungWitchExtractCostRange.include?( vol[:cost].to_i )
			}.to_a.sample[0]
		end
		return ret
	end
end