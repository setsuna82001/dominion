# coding: utf-8
class Base < DominionLib
	
	BaseRelateList	= ( 1 .. 7 ).to_a
	
	def initialize( card, series_num )
		super(	card, series_num,
			{ :delete => BaseRelateList }
		)
	end
	
end