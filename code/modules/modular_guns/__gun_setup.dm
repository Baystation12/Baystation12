//Gun loading types
#define SINGLE_CASING 	1	//The gun only accepts ammo_casings. ammo_magazines should never have this as their mag_type.
#define SPEEDLOADER 	2	//Transfers casings from the mag to the gun when used.
#define MAGAZINE 		4	//The magazine item itself goes inside the gun

#define HOLD_CASINGS	0 //do not do anything after firing. Manual action, like pump shotguns, or guns that want to define custom behaviour
#define EJECT_CASINGS	1 //drop spent casings on the ground after firing
#define CYCLE_CASINGS 	2 //experimental: cycle casings, like a revolver. Also works for multibarrelled guns
#define DESTROY_CASINGS 3

#define CALIBER_CANNON           "20mm gyrojet"
#define CALIBER_GRENADE          "40mm grenade"
#define CALIBER_ROCKET           "66mm rocket"
#define CALIBER_PISTOL_SMALL     "5.7mm"
#define CALIBER_PISTOL_MEDIUM    "9mm"
#define CALIBER_PISTOL_LARGE     "10mm"
#define CALIBER_RIFLE_SMALL      ".223"
#define CALIBER_RIFLE_LARGE      ".308"
#define CALIBER_357              ".357"
#define CALIBER_38               ".38"
#define CALIBER_45               ".45"
#define CALIBER_RIFLE_SNIPER     ".50 BMG"
#define CALIBER_MAGNUM           ".50 AE"
#define CALIBER_SHOTGUN          "12 gauge"
#define CALIBER_LASER            "laser"
#define CALIBER_LASER_PRACTICE   "practice laser"
#define CALIBER_LASER_MID        "mid-power laser"
#define CALIBER_LASER_HEAVY      "high-power laser"
#define CALIBER_LASER_WEAK       "low-intensity laser"
#define CALIBER_LASER_XRAY       "\improper X-ray"
#define CALIBER_LASER_INDUSTRIAL "industrial laser"
#define CALIBER_LASER_LASERTAG   "laser tag"
#define CALIBER_LASER_PRECISION  "precision laser"
#define CALIBER_LASER_SHOCK      "taser beam"
#define CALIBER_LASER_SHOTGUN    "burst laser"
#define CALIBER_LASER_TASER      "microwave"
#define CALIBER_TOY              "capgun"
#define CALIBER_DART             "dart"
#define CALIBER_ALIEN            "xenoarch"
#define CALIBER_LASER_PULSE      "pulse beam"
#define CALIBER_LASER_ION        "ion beam"
#define CALIBER_LASER_STUNSHOT   "stunshot"
#define CALIBER_STAFF_ANIMATE    "anima spellshot"
#define CALIBER_STAFF_CHANGE     "polymorph spellshot"
#define CALIBER_STAFF_FORCE      "kinetic spellshot"

#define AMMO_6MM                 "FN 5.7x28"
#define AMMO_9MM                 "9mm Parabellum"
#define AMMO_10MM                ".45 ACP"
#define AMMO_556                 "5.56 NATO"
#define AMMO_762                 "7.62 NATO"
#define AMMO_MAGNUM              ".50 AE"
#define AMMO_SNIPER              ".50 BMG"
#define AMMO_SHOTGUN             "12 gauge shot"

#define GUN_PISTOL  "pistol"
#define GUN_SMG     "smg"
#define GUN_RIFLE   "rifle"
#define GUN_CANNON  "cannon"
#define GUN_ASSAULT "assault"
#define GUN_SHOTGUN "shotgun"

#define GUN_TYPE_ELECTROSHOCK "shock"
#define GUN_TYPE_LASER        "laser"
#define GUN_TYPE_BALLISTIC    "ballistic"
#define GUN_TYPE_INCENDIARY   "incendiary"
#define GUN_TYPE_MAGNETIC     "railgun"

#define COMPONENT_BARREL    "barrel"
#define COMPONENT_BODY      "body"
#define COMPONENT_MECHANISM "chamber"
#define COMPONENT_GRIP      "grip"
#define COMPONENT_STOCK     "stock"
#define COMPONENT_ACCESSORY "accessory"

#define COLOR_SUN              "#ec8b2f"
#define COLOR_GUNMETAL         "#6b6569"
#define COLOR_WOODFINISH       "#8c6424"

/obj/item/weapon/gun/proc/reset_name()
	return initial(name)

/obj/item/weapon/gun/var/recoil = 0 //screen shake
