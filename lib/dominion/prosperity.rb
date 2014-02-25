# coding: utf-8
class Prosperity < DominionLib
	
	ColonyNumber	= 115	#植民地
	PlatinumNumber	= 122	#白金貨
	
	def initialize( card, series_num )
		super(	card, series_num,
				{ :relate => [ ColonyNumber, PlatinumNumber ] }
		)
	end
	
	def get_relate_supply( main_list = nil )
		ret			= Array.new
		self_list	= main_list.select{| id | @card_list[ id ][ :series ] == @series_num }
		ret << ColonyNumber		if rand( main_list.size ) > self_list.size
		ret << PlatinumNumber	if rand( main_list.size ) > self_list.size
		return ret
	end

end