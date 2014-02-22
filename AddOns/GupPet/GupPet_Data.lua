--[[ 	GupPet by Gup 	]]--

-- typeMount --> 1 = 60%
			 --> 2 = 100%
			 --> 11 = 150% (fly)
			 --> 12 = 280% (fly) 
			 --> 13 = 310% (fly)
			 
			 --> 21 = 60% (Swimming) 
			 
			 -->  30 = Snowball needed
			 
			
GUPPET_CLASSDATA = { 	DRUID  = { Travel = 783 , SlowFly = 33943 , FastFly = 40120 , Aquatic = 1066 , Bear = 5487 , Cat = 768 } , 
						SHAMAN = { Ghost = 2645 , WaterWalking = 546 },
						HUNTER = { Pack = 13159 , Cheetah = 5118 , FeignDeath = 5384 , Camouflage = 51753 }, 
						MAGE   = { SlowFall = 130,  Invisibility = 66},
						PRIEST = { SpiritOfRedemption = 20711},
						DEATHKNIGHT = { PathOfFrost = 3714},
						WORGEN = { Darkflight=68992 , RunningWild = 87840 }
					}

GUPPET_ITEMDATA = { Food = 64355 ,
					Drink = 57073,
					
					SeaLegs = 73701,
					
					Quest = { 
						[18597] = {}, -- Orcish Orphan Whistle
						[18598] = {}, -- Human Orphan Whistle
						[30803] = {"Hellfire"}, -- Felhound Whistle
						[31815] = {"Netherstorm"}, -- Zeppit's Crystal 						
						[31880] = {}, -- Blood Elf Orphan Whistle
						[31881] = {}, -- Draenei Orphan Whistle
						[34253] = {"Hellfire"}, -- Sizzling Ember		
						[34971] = {"BoreanTundra"}, -- Warsong Flare Gun 
						[36936] = {"GrizzlyHills"}, -- Golem Control Unit 	 
						[39319] = {"ZulDrak"}, -- Scepter of Domination 
						[46362] = {"UngoroCrater", "Tanaris", "Silithus"}, -- Venomhide Hatchling
						[46396] = {}, -- Wolvar Orphan Whistle
						[46397] = {} -- Oracle Orphan Whistle
						}
			 		}
 

GUPPET_COMPANIONDATA = {

	---------------------------------------------------------------------------
	[26533] = {[30] = true},		-- Father Winter's Helper
	[26529]	= {[30] = true},		-- Winter Reindeer
	[26541] = {[30] = true},		-- Winter's Little Helper
	[26045] = {[30] = true},		-- Tiny Snowman
}	;




