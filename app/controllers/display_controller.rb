require 'base64'
require 'ipaddr'
class DisplayController < ApplicationController
  #const
  SUPPLY_SIZE         = 10  # サプライのサイズ
  DECK_SIZE           = 3   # 初期デッキ数
  ADD_DECK_BASE_CARD  = 4   # 屋敷
  GAME_BASE_CARD_LIST = ( 1 .. 7 ).to_a
  LISTPATH  = "#{Rails.root}/config/dominion_list"
  LIBPATH   = "#{Rails.root}/lib/dominion"
  
  # variables
  @@variables = [ :card, :series, :type, :genre ]
  @@symbols   = [ :mainlist, :sublist, :decklist, :optionlist ]
  
  def initialize
    load( "#{LIBPATH}/dominion.rb" )
    @@variables.each{| name |
      load( "#{LISTPATH}/#{name}.rb" )
      
      begin
        eval( "@#{name} = #{name.capitalize}::List" )
      rescue
        eval( "@#{name} = Array.new" )
      end
    }

    super
  end
  
  def index
    @params           = checkParams( params )
    @playable_series  = Array.new
    @select_series    = Hash.new
    @@symbols.each{| sym |
      eval( "@#{ sym } = reservKeyList( @params[ :#{ sym } ] )" )
    }

    # check each params
    reservSeries( @params[:series]  )
    if( @mainlist.empty? && @params[:series].empty? )
      # first access judge
      @@symbols.each{| sym | @params[ sym ] = '' }
      return nil
    end

    # check params
    loadClasses( )            # 各クラスを読み込み
    makePlaybleCardList( )    # @listsを有効なカードのみに
    makePlaybleSeriesList(  ) # @listsからシリーズを選定
    if @mainlist.size > SUPPLY_SIZE
      makeKeyList( @mainlist[ 0, SUPPLY_SIZE ] )
      return nil
    elsif @mainlist.size == SUPPLY_SIZE
      makeKeyList( @mainlist )
      return nil
    end
    
    # select supply
    while( @mainlist.size < SUPPLY_SIZE )
      @select_series.select{| key, vol | vol == @select_series.values.min }.keys.sample.tap{| num |
        eval( "@mainlist << @#{@series[num][:text]}.select_supply" )
        @select_series[ num ] += 1
      }
    end

    makeKeyList( @mainlist )
  end
  
  protected
  def loadClasses( )
    @series.each{| key, vol |
      text = vol[:text]
      if vol[:playable]
        load( "#{LIBPATH}/#{text.downcase}.rb" )
        eval( "@#{text} = #{text}.new( @card, key )" )
        eval( "@playable_series << @#{text}" )
        eval( "@select_series[key] = 0" )
      end
    }
  end
  
  def makePlaybleCardList( )
    sub = []
    @mainlist.each{| id |
      arr = @playable_series.map{| obj |
        obj.isMainCard?( id )
      }.select{| obj | obj.to_i > 0 }
      
      if arr.empty?
        sub << id
      else
        @select_series[ @card[ id ][:series] ] += 1
      end
    }
    @mainlist -= sub
  end
  
  def makePlaybleSeriesList( )
    arr = @mainlist.map{| num | @card[ num ][:series] }
    @params[:series]  = ( @params[:series] + arr ).uniq
    
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
      ( @series[num][:playable] )? num : nil
    }.compact
  end
  
  def makeKeyList( lists )
    @mainlist = lists.sort
    
    # select sub supply
    if ( @sublist & GAME_BASE_CARD_LIST ).size != GAME_BASE_CARD_LIST.size
      @sublist = GAME_BASE_CARD_LIST
      @playable_series.each{| obj |
        @sublist += obj.get_relate_supply( @mainlist )
      }
      @sublist.uniq!
    end
    
    # deck cards extract
    if @decklist.size != DECK_SIZE
      @playable_series.each{| obj |
        @decklist += obj.get_deck_supply( @mainlist )
      }

      @decklist.uniq!
      if @decklist.uniq.size < DECK_SIZE
        ( DECK_SIZE - @decklist.size ).times{
          @decklist << ADD_DECK_BASE_CARD
        }
      end
      @decklist = @decklist[ 0, DECK_SIZE ].sort
    end
    
    # option cards extract
    if @optionlist.size.zero?
      selectable_mainlist = @playable_series.inject({}){| hsh, obj | hsh.merge!( obj.mainlist ) }
      @playable_series.each{| obj |
        @optionlist += obj.get_option_supply( {
            mainlist:       @mainlist,
            select_series:  @select_series,
            card_list:      selectable_mainlist
        } )
      }
    end
    
    @@symbols.each{| sym |
      eval( "@params[:#{sym}] = @#{ sym }.inject(''){| str, num | str += ( \"%02x\" % num ) }" )
    }
    
  end
  
  def checkParams( param )
    param[ :series ]  = [] unless param.key?( :series )

    @@symbols.each{| sym |
      param[ sym ]    = '' unless param.key?( sym )
    }
    return param
  end
end
