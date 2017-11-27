//All the flags for Grenade traits are held in this file. Unfortunately restricts us to a limited amount of traits,
//but that's an idea-man's problem. DO NOT FUCKING MINGLE THE FIRST AND SECOND LIST SHIT WILL BREAK


//Grenade supertypes, Don't fucking hybridize these I swear to god it'll break everythin


//Spawns mobs. Skips all other behaviors if present.
#define SPAWNER 0x1

//Spawner part uses 5 complexity.
//Old spawnernades generally spawn 5 mobs. Thus: Spawnernades will be power = 5 with one spawner part.

//Offensive grenades: HE; Fragmentation;  Concussion; Incendiary; Taze; Tesla; Gravitating; Laser; Scatter (Caltrops et al), STING
#define EXPLOSIVE 0x2
#define FRAGMENTING 0x4
#define CONCUSSIVE 0x8
#define INCENDIARY 0x10
#define TAZE 0x20
#define TESLA 0x40
#define GRAV 0x80
#define LASER 0x100
#define SCATTER 0x200
#define STING 0x400

//Start second flag list.

/*
Tactical grenades: Flashbang; Daze; EMP; Darkness
*/

#define FLASHING 0x800
#define DEAFENING 0x1000
#define DAZING 0x2000
#define EM-PULSING 0x4000
#define DARKNESS 0x8000


//Start second flag list. Fucking byond.


#define SMOKE 0x1



