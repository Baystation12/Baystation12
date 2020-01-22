#define GENERIC 0
#define PADDED_CELL 1
#define ROOM 2
#define BATHROOM 3
#define LIVINGROOM 4
#define STONEROOM 5
#define AUDITORIUM 6
#define CONCERT_HALL 7
#define CAVE 8
#define ARENA 9
#define HANGAR 10
#define CARPETED_HALLWAY 11
#define HALLWAY 12
#define STONE_CORRIDOR 13
#define ALLEY 14
#define FOREST 15
#define CITY 16
#define MOUNTAINS 17
#define QUARRY 18
#define PLAIN 19
#define PARKING_LOT 20
#define SEWER_PIPE 21
#define UNDERWATER 22
#define DRUGGED 23
#define DIZZY 24
#define PSYCHOTIC 25

#define STANDARD_STATION STONEROOM
#define LARGE_ENCLOSED HANGAR
#define SMALL_ENCLOSED BATHROOM
#define TUNNEL_ENCLOSED CAVE
#define LARGE_SOFTFLOOR CARPETED_HALLWAY
#define MEDIUM_SOFTFLOOR LIVINGROOM
#define SMALL_SOFTFLOOR ROOM
#define ASTEROID CAVE
#define SPACE UNDERWATER
/area/dante
	requires_power = 0
	has_gravity = 1

/area/dante/deck2

/area/achlys
	name = "Achlys Test Area"
	ambience = list('sound/ambience/ambiatm1.ogg','sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen10.ogg',\
					'sound/ambience/shipclunk.ogg','sound/ambience/shipcreak2.ogg','sound/ambience/shipclunk2.ogg','sound/ambience/ventclunk.ogg','sound/ambience/shipcreak.ogg')
	sound_env = STANDARD_STATION

/area/achlys/one
	sound_env = LARGE_ENCLOSED
	name = "wide open areas"
/area/achlys/eight/z1main
/area/achlys/one/z2main1
/area/achlys/one/z2main2
/area/achlys/one/z3upperengineeringbay
/area/achlys/one/z3prisonupper1
/area/achlys/one/z3prisonupper2
/area/achlys/one/z3prisonupper3
/area/achlys/one/z3prisonupper4
/area/achlys/four/z4engineeringmain
/area/achlys/three
	sound_env = HALLWAY
	name = "long hallways"
/area/achlys/three/z1sechallway
/area/achlys/three/z3dormhalls
/area/achlys/three/z3sciencehalls
/area/achlys/three/z3engineeringhall1
/area/achlys/three/z3engineeringhall2
/area/achlys/three/z4hallways
/area/achlys/four
	sound_env = SMALL_ENCLOSED
	name = "cargo bays and hangars"
/area/achlys/four/z1hangerbay
/area/achlys/four/z3blockhall1
/area/achlys/four/z3blockhall2
/area/achlys/four/z3engineeringmain
/area/achlys/four/z4hanger1
/area/achlys/four/z4hanger2
/area/achlys/five
	sound_env = LARGE_SOFTFLOOR
	name = "carpeted areas"
/area/achlys/five/z1secpoint1
/area/achlys/five/z1secpoint2
/area/achlys/five/z1secpoint3
/area/achlys/five/z1secpoint4
/area/achlys/five/z1bathroom1
/area/achlys/five/z1bathroom2
/area/achlys/five/z1laundry
/area/achlys/five/z1ladder1
/area/achlys/five/z1ladder2
/area/achlys/five/z2freezer
/area/achlys/five/z2secpoint1
/area/achlys/five/z3scienceaux
/area/achlys/five/z3stairway1
/area/achlys/five/z3stairway2
/area/achlys/five/z3lounge
/area/achlys/five/z3secpoint
/area/achlys/five/z4basketball
/area/achlys/five/z4showers1
/area/achlys/five/z4secstation1
/area/achlys/five/z4secstation2
/area/achlys/two
	sound_env = SPACE
	name = "enclosed rooms"
/area/achlys/two/z1freezerpod
/area/achlys/two/z1femlocker
/area/achlys/two/z1malelocker
/area/achlys/two/z1hos
/area/achlys/two/z1morgue
/area/achlys/two/z2maintroom1
/area/achlys/two/z2maintroom2
/area/achlys/two/z2maintroom3
/area/achlys/two/z2maintroom4
/area/achlys/two/z2maintroom5
/area/achlys/two/z2maintroom6
/area/achlys/two/z2maintroom7
/area/achlys/two/z2barbackroom
/area/achlys/two/z3escape1
/area/achlys/two/z3escape2
/area/achlys/two/z3escape3
/area/achlys/two/z3escape4
/area/achlys/two/z3tearoom
/area/achlys/two/z4cells1
/area/achlys/two/z4cells2
/area/achlys/two/z4cells3
/area/achlys/two/z4cells4
/area/achlys/two/z4cells5
/area/achlys/two/z4cells6
/area/achlys/six
	sound_env = HANGAR
	name = "medium sized rooms"
/area/achlys/six/z1infirmary
/area/achlys/six/z1offices
/area/achlys/six/z2cafeterias
/area/achlys/six/z2breakroom
/area/achlys/six/z3engineeringstorage
/area/achlys/six/z3armory
/area/achlys/six/z3sciencecafeteria
/area/achlys/six/z3sciencemain
/area/achlys/six/z4barrack1
/area/achlys/six/z4barrack2
/area/achlys/seven
	sound_env = STONE_CORRIDOR
	name = "bridge hallway"
/area/achlys/seven/z1bridgewalkway
	requires_power = 0
/area/achlys/seven/z2mainthalls
/area/achlys/seven/z3mainthalls
/area/achlys/seven/z4maint1
/area/achlys/seven/z4maint2
/area/achlys/seven/z4maint3
/area/achlys/seven/z4maint4
/area/achlys/seven/z4maint5
/area/achlys/seven/z4secpoint1
/area/achlys/seven/z4secpoint2
/area/achlys/seven/z4secpoint3
/area/achlys/eight
	sound_env = ALLEY
	name = "spacious hallways"
/area/achlys/eight/z1cargohallway
/area/achlys/eight/z1meetinghall
/area/achlys/one/z1hangerhallway
/area/achlys/eight/z2cargoandhalls
/area/achlys/eight/z4engineeringseconary
/area/achlys/eight/z4cellblock1
/area/achlys/eight/z4cellblock2
/area/achlys/eight/z4cellblock3
/area/achlys/eight/z4cellblock4
/area/achlys/nine
	name = "small rooms"
	sound_env = SMALL_SOFTFLOOR
/area/achlys/nine/z1bridge
	requires_power = 0
/area/achlys/nine/z1commandhallway
/area/achlys/nine/z2bar
/area/achlys/nine/z3carpetdorms1
/area/achlys/nine/z3carpetdorms2
/area/achlys/nine/z3sciencecubicles
/area/achlys/nine/z3sciencemaint
/area/achlys/nine/z3guardhall
/area/achlys/nine/z4laundry1
/area/achlys/nine/z4medical1
/area/achlys/nine/z4secpoint1
/area/achlys/nine/z4tableroom
/area/achlys/nine/z4breakroom
