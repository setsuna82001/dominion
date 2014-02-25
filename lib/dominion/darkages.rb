# coding: utf-8
class Darkages < DominionLib
	#Knights
	KnightsNumber			= 178
	SirVanderNumber			= 179
	SirDestryNumber			= 180
	SirBaileyNumber			= 181
	SirMartinNumber			= 182
	SirMichaelNumber		= 183
	DameAnnaNumber			= 184
	DameJosephineNumber		= 185
	DameSylviaNumber		= 186
	DameNatalieNumber		= 187
	DameMollyNumber			= 188
	Knights					= [	SirVanderNumber, SirDestryNumber, SirBaileyNumber, SirMartinNumber, SirMichaelNumber, 
								DameAnnaNumber, DameJosephineNumber, DameSylviaNumber, DameNatalieNumber, DameMollyNumber
							]
	#Shelters
	NecropolisNumber		= 193	#共同墓地
	OvergrownEstateNumber	= 195	#草茂る屋敷
	HovelNumber				= 212	#納屋
	Shelters				= [ NecropolisNumber, OvergrownEstateNumber, HovelNumber ]
	
	#Ruins
	RuinedMarketNumber		= 174	#市場跡地
	SurvivorsNumber			= 207	#生存者
	RuinedLibraryNumber		= 211	#図書館跡地
	AbandonedMineNumber		= 214	#廃坑
	RuinedVillageNumber		= 215	#廃村
	Ruins					= [	RuinedMarketNumber, SurvivorsNumber, RuinedLibraryNumber, AbandonedMineNumber, RuinedVillageNumber ]
	DeathCartNumber			= 203	#死の荷車
	CultistNumber			= 192	#狂信者
	
	
	HermitNumber			= 175	#隠遁者
	MadmanNumber			= 191	#狂人

	UrchinNumber			= 221	#浮浪児
	MercenaryNumber			= 226	#傭兵
	
	BanditCampNumber		= 202	#山賊の宿営地
	PillageNumber			= 227	#略奪
	MarauderNumber			= 204	#襲撃者
	SpoilsNumber			= 228	#略奪品
	
	CardRelations			= {
		KnightsNumber		=> Knights,
		DeathCartNumber		=> Ruins,
		CultistNumber		=> Ruins,
		MarauderNumber		=> Ruins + [ SpoilsNumber ],
		HermitNumber		=> [ MadmanNumber ],
		UrchinNumber		=> [ MercenaryNumber ],
		BanditCampNumber	=> [ SpoilsNumber ],
		PillageNumber		=> [ SpoilsNumber ],
	}
	
	def initialize( card, series_num )
		super(	card, series_num,
				{	:relate => Ruins + [ MadmanNumber, MercenaryNumber, SpoilsNumber ],
					:delete => Knights,
					:option => Shelters
				}
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
	
end