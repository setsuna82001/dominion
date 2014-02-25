require 'base64'
require 'ipaddr'
class DisplayController < ApplicationController
	#const
	SUPPLY_SIZE	= 10
	GAME_BASE_CARD_LIST	= ( 1 .. 7 ).to_a
	DBPATH	= "#{Rails.root}/config/dominion_list"
	LIBPATH	= "#{Rails.root}/lib/dominion"
	
	# variables
	@@variables	= [ 'card', 'series', 'type' ]
	@@symbols	= [ :mainlist, :sublist, :optlist ]
	
	def initialize
		load( "#{LIBPATH}/dominion.rb" )
		@@variables.each{| name |
			load( "#{DBPATH}/#{name}.rb" )
			
			begin
				eval( "@#{name} = #{name.capitalize}::List" )
			rescue
				eval( "@#{name} = Array.new" )
			end
		}

		super
	end
	
	def index
		@params	= checkParams( params )
		@main_lists		= reservKeyList( @params[ :mainlist ] )
		@sub_lists		= reservKeyList( @params[ :sublist ] )
		@opt_lists		= reservKeyList( @params[ :optlist ] )
		@playable_series	= Array.new
		@select_series		= Hash.new

		# check each params
		reservSeries( @params[:series]  )
		if( @main_lists.empty? && @params[:series].empty? )
			# first access judge
			@@symbols.each{| sym | @params[ sym ] = '' }
			return nil
		end

		# check params
		loadClasses( )				# モジュールクラスを読み込み
		makePlaybleCardList( )		# @listsを有効なカードのみに
		makePlaybleSeriesList(  )	# @listsからシリーズを選定
		if @main_lists.size > SUPPLY_SIZE
			makeKeyList( @main_lists[ 0, SUPPLY_SIZE ] )
			return nil
		elsif @main_lists.size == SUPPLY_SIZE
			makeKeyList( @main_lists )
			return nil
		end
		
		# select supply
		while( @main_lists.size < SUPPLY_SIZE )
			@select_series.select{| key, vol | vol == @select_series.values.min }.keys.sample.tap{| num |
				eval( "@main_lists << @#{@series[num][:text]}.select_supply" )
				@select_series[ num ] += 1
			}
		end

		makeKeyList( @main_lists )
	end
	
	protected
	def loadClasses( )
		@series.each{| key, vol |
			text = vol[:text]
			unless text.empty?
				load( "#{LIBPATH}/#{text.downcase}.rb" )
				eval( "@#{text} = #{text}.new( @card, key )" )
				eval( "@playable_series << @#{text}" )
				eval( "@select_series[key] = 0" )
			end
		}
	end
	
	def makePlaybleCardList( )
		sub = []
		@main_lists.each{| id |
			arr = @playable_series.map{| obj |
				obj.isMainCard?( id )
			}.select{| obj | obj.to_i > 0 }
			
			if arr.empty?
				sub << id
			else
				@select_series[ @card[ id ][:series] ] += 1
			end
		}
		@main_lists -= sub
	end
	
	def makePlaybleSeriesList( )
		arr					= @main_lists.map{| num | @card[ num ][:series] }
		@params[:series]	= ( @params[:series] + arr ).uniq
		
		@select_series.each{| key, vol |
			@select_series.delete( key ) unless @params[:series].include?( key )
		}
	end
	
	def reservKeyList( args )
		ret = Array.new
		args.unpack( "a2" * ( args.size / 2 ) ).each{| str |
			ret << str.hex unless @card[ str.hex ].nil?
		}
		return ret
	end

	def reservSeries( args )
		@params[ :series ] = args.map{| str |
			num = str.to_i
			( @series[num][:text].empty? )? nil : num
		}.compact
	end
	
	def makeKeyList( lists )
		@main_lists = lists.sort
		
		# select sub supply
		unless ( @sub_lists & GAME_BASE_CARD_LIST ).size == GAME_BASE_CARD_LIST.size
			@sub_lists = GAME_BASE_CARD_LIST
			@playable_series.each{| obj |
				@sub_lists += obj.get_relate_supply( @main_lists )
			}
		end
		
		# option cards extract
		if @opt_lists.size.zero?
			@playable_series.each{| obj |
				@opt_lists += obj.get_option_supply( @main_lists )
			}
		end
		

		@@symbols.each{| sym |
			eval( "@params[:#{sym}] = @#{ sym.to_s.sub( 'list', '_lists' ) }.inject(''){| str, num | str += ( \"%02x\" % num ) }" )
		}
		
		
#		@params[ :mainlist ]	= @main_lists.inject(''){| str, num | str += ( "%02x" % num ) }
#		@params[ :sublist ]		= @sub_lists.inject(''){ | str, num | str += ( "%02x" % num ) }
#		@params[ :optlist ]		= @opt_lists.inject(''){ | str, num | str += ( "%02x" % num ) }
	end
	
	def checkParams( param )
		param[ :series ]	= [] unless param.key?( :series )

		@@symbols.each{| sym |
			param[ sym ]	= '' unless param.key?( sym )
		}
		return param
	end
end
