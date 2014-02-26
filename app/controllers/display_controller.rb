require 'base64'
require 'ipaddr'
class DisplayController < ApplicationController
	#const
	SUPPLY_SIZE			= 10	# サプライのサイズ
	DECK_SIZE			= 3		# 初期デッキ数
	ADD_DECK_BASE_CARD	= 4		# 屋敷
	GAME_BASE_CARD_LIST	= ( 1 .. 7 ).to_a
	DBPATH	= "#{Rails.root}/config/dominion_list"
	LIBPATH	= "#{Rails.root}/lib/dominion"
	
	# variables
	@@variables	= [ 'card', 'series', 'type' ]
	@@symbols	= [ :mainlist, :sublist, :decklist ]
	
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
		@deck_lists		= reservKeyList( @params[ :decklist ] )
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
		loadClasses( )				# 各クラスを読み込み
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
		if ( @sub_lists & GAME_BASE_CARD_LIST ).size != GAME_BASE_CARD_LIST.size
			@sub_lists = GAME_BASE_CARD_LIST
			@playable_series.each{| obj |
				@sub_lists += obj.get_relate_supply( @main_lists )
			}
			@sub_lists.uniq!
		end

		# TODO 災い
		
		# option cards extract
		if @deck_lists.size.zero?
			@playable_series.each{| obj |
				@deck_lists += obj.get_deck_supply( {
						main_list:		@main_lists,
						select_series:	@select_series,
				} )
			}

			@deck_lists.uniq!
			if @deck_lists.uniq.size < DECK_SIZE
				( DECK_SIZE - @deck_lists.size ).times{
					@deck_lists << ADD_DECK_BASE_CARD
				}
			end
			@deck_lists = @deck_lists[ 0, DECK_SIZE ].sort
		end

		@@symbols.each{| sym |
			eval( "@params[:#{sym}] = @#{ sym.to_s.sub( 'list', '_lists' ) }.inject(''){| str, num | str += ( \"%02x\" % num ) }" )
		}
		
	end
	
	def checkParams( param )
		param[ :series ]	= [] unless param.key?( :series )

		@@symbols.each{| sym |
			param[ sym ]	= '' unless param.key?( sym )
		}
		return param
	end
end
