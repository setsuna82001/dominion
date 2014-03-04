# coding: utf-8
class Alchemy < DominionLib
	
	PotionNumber			= 97	#ポーション
	PhilosophersStoneNumber	= 88	#賢者の石
	
	def initialize( card, series_num )
		super(	card, series_num,
				{ :relate => [ PotionNumber, PhilosophersStoneNumber ] }
		)
	end
	
	def get_relate_supply( mainlist = nil )
		ret			= Array.new
		self_list	= mainlist.select{| id | @card_list[ id ][ :series ] == @series_num }
		ret << PotionNumber				if self_list.size > 0
		ret << PhilosophersStoneNumber	if ( rand( mainlist.size ) + 1 ) <= self_list.size
		return ret
	end
end