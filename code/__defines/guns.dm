#define CALIBER_PISTOL 			"10mm"
#define CALIBER_PISTOL_SMALL 	"7mm"
#define CALIBER_PISTOL_MAGNUM 	"15mm"
#define CALIBER_PISTOL_FLECHETTE "4mm"
#define CALIBER_PISTOL_ANTIQUE	"~10mm"

#define CALIBER_RIFLE			"7mmR"
#define CALIBER_RIFLE_MILITARY  "5mmR"
#define CALIBER_ANTIMATERIAL    "15mmR"

#define CALIBER_SHOTGUN			"12g"
#define CALIBER_GYROJET			"20mmG"
#define CALIBER_CAPS			"caps"
#define CALIBER_DART			"darts"

#define HOLD_CASINGS	0 //do not do anything after firing. Manual action, like pump shotguns, or guns that want to define custom behaviour
#define CLEAR_CASINGS	1 //clear chambered so that the next round will be automatically loaded and fired, but don't drop anything on the floor
#define EJECT_CASINGS	2 //drop spent casings on the ground after firing
#define CYCLE_CASINGS	3 //cycle casings, like a revolver. Also works for multibarrelled guns

//Gun loading types
#define SINGLE_CASING 	1	//The gun only accepts ammo_casings. ammo_magazines should never have this as their mag_type.
#define SPEEDLOADER 	2	//Transfers casings from the mag to the gun when used.
#define MAGAZINE 		4	//The magazine item itself goes inside the gun
