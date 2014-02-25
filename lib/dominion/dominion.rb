# coding: utf-8
class DominionLib
	
	attr_accessor	:series_name, :series_num,
					:relate_list, :option_list,
					:main_list,	:sub_list
	
	def initialize( card, series_num, sub = {} )
		@card_list		= card
		@series_name	= self.class.to_s
		@series_num		= series_num
		@relate_list	= Hash.new
		@option_list	= Hash.new
		@main_list		= Hash.new
		@sub_list		= Hash.new
		
		card.each{| key, vol |
			if vol[:series] == series_num
				@main_list[key] = vol
			end
		}
		
		sub.each{| key, vol |
			eval( "#{key}Pcoress( #{vol} )" );
		}
	end
	
	def select_supply( id = nil )
		id = @main_list.to_a.sample[0] unless id
		deleteMainCard( id )
		return id
	end
	
	def isMainCard?( id )
		bln = @main_list.key?( id )
		return ( bln ) ? select_supply( id ) : nil
	end
	
	def method_missing( name, args = nil )
		return []	if [ :get_relate_supply, :get_option_supply ].include?( name )
		return nil
    end
	
	def inspect
		"<#{@series_name}:" +
			"".tap{| o | break "\t" if @series_name.size <= 5 } + 
			"\t@series_num=#{@series_num}" +

			self.instance_variables.select{| sym |
				instance_variable_get( sym ).kind_of?( Hash )
			}.map{| sym |
				"  #{sym}[#{ "%02d" % instance_variable_get( sym ).size }]"
			}.join('') + 
			
		"  >"
	end
	
	protected
	def deleteMainCard( id )
		@main_list.delete( id ) if @main_list.key?( id )
		return id
	end

	def relatePcoress( list )
		list.each{| id |
			if @main_list.key?( id )
				@relate_list[id] = @main_list[id]
				deleteMainCard( id )
			end
		}
	end
	def optionPcoress( list )
		list.each{| id |
			if @main_list.key?( id )
				@option_list[id] = @main_list[id]
				deleteMainCard( id )
			end
		}
	end
	def deletePcoress( list )
		list.each{| id | deleteMainCard( id ) }
	end
	
end