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

/area/achlys
	name = "Achlys Test Area"
	ambience = list('sound/ambience/ambiatm1.ogg','sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen10.ogg')
	sound_env = STANDARD_STATION

/area/achlys/one
	sound_env = LARGE_ENCLOSED
	name = "wide open areas"
/area/achlys/three
	sound_env = HALLWAY
	name = "long hallways"
/area/achlys/four
	sound_env = SMALL_ENCLOSED
	name = "cargo bays and hangars"
/area/achlys/five
	sound_env = LARGE_SOFTFLOOR
	name = "carpeted areas"
/area/achlys/two
	sound_env = SPACE
	name = "enclosed rooms"
/area/achlys/six
	sound_env = HANGAR
	name = "medium sized rooms"
/area/achlys/seven
	sound_env = STONE_CORRIDOR
	name = "bridge hallway"
/area/achlys/eight
	sound_env = ALLEY
	name = "spacious hallways"