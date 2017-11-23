//All the flags for Grenade traits are held in this file. Unfortunately restricts us to a limited amount of traits, but that's an idea-man's problem. We have enough bitflags.

//Killy grenades. Includes less than lethal grenades.
#define OFFENSIVE 0x1

//Hindering grenades;
#define TACTICAL 0x2

//Deferr to chemnade mechanics if present.
#define UTILITY 0x4

#define SPAWNER 0x8

//Offensive grenades: HE; Fragmentation;  Concussion; Incendiary; Taze; Tesla; Gravitating; Laser; Scatter (Caltrops et al), STING
#define EXPLOSIVE 0x10
#define FRAGMENTING 0x20
#define CONCUSSIVE 0x40
#define INCENDIARY 0x60
#define TAZE 0x80
#define TESLA 0x100
#define GRAV 0x200
#define LASER 0x400
#define SCATTER 0x600
#define STING 0x800

/*
Tactical grenades: Flashbang; Daze; EMP; Darkness
*/

#define FLASHING 0x1000
#define DEAFENING 0x2000
#define DAZING 0x4000
#define EM-PULSING 0x6000
#define DARKNESS 0x8000

