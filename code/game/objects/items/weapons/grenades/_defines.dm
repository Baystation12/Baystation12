//All the flags for Grenade traits are held in this file. Unfortunately restricts us to a limited amount of traits,
//but that's an idea-man's problem. DO NOT FUCKING MINGLE THE FIRST AND SECOND LIST SHIT WILL BREAK


//Grenade supertypes, Don't fucking hybridize these I swear to god it'll break everythin

//Killy grenades. Includes less than lethal grenades.
#define OFFENSIVE 0x1

//Hindering grenades;
#define TACTICAL 0x2

//Deferr to chemnade mechanics if present.
#define UTILITY 0x4

//Spawns mobs.
#define SPAWNER 0x8

//Offensive grenades: HE; Fragmentation;  Concussion; Incendiary; Taze; Tesla; Gravitating; Laser; Scatter (Caltrops et al), STING
#define EXPLOSIVE 0x10
#define FRAGMENTING 0x20
#define CONCUSSIVE 0x40
#define INCENDIARY 0x80
#define TAZE 0x100
#define TESLA 0x200
#define GRAV 0x400
#define LASER 0x800
#define SCATTER 0x1000
#define STING 0x2000

//Start second flag list.

/*
Tactical grenades: Flashbang; Daze; EMP; Darkness
*/

#define FLASHING 0x4000
#define DEAFENING 0x8000
#define DAZING 0x8000

//Start second flag list.


#define EM-PULSING 0x1
#define DARKNESS 0x2
#define SMOKE 0x4



