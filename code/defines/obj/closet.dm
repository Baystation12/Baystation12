/obj/structure/closet
	name = "Closet"
	desc = "It's a closet."
	icon = 'closet.dmi'
	icon_state = "closed"
	density = 1
	var/icon_closed = "closed"
	var/icon_opened = "open"
	var/opened = 0
	var/welded = 0
	var/wall_mounted = 0 //never solid (You can always pass over it)
	flags = FPRINT
	var/health = 100
	var/lastbang
	var/lasttry = 0
	layer = 2.98

/obj/structure/closet/detective
	name = "Detective's Closet"
	desc = "Holds the detective's clothes while his coat rack is being repaired."

/obj/structure/closet/acloset
	name = "Strange closet"
	desc = "It looks weird."
	icon_state = "acloset"
	icon_closed = "acloset"
	icon_opened = "aclosetopen"

/obj/structure/closet/cabinet
	name = "Cabinet"
	desc = "Old will forever be in fashion."
	icon_state = "cabinet_closed"
	icon_closed = "cabinet_closed"
	icon_opened = "cabinet_open"

/obj/effect/spresent
	name = "strange present"
	desc = "It's a ... present?"
	icon = 'items.dmi'
	icon_state = "strangepresent"
	density = 1
	anchored = 0

/obj/structure/closet/gmcloset
	name = "Formal closet"
	desc = "A bulky (yet mobile) closet. Comes with formal clothes."

/obj/structure/closet/emcloset
	name = "Emergency Closet"
	desc = "A bulky (yet mobile) closet. Comes prestocked with a gasmask and o2 tank for emergencies."
	icon_state = "emergency"
	icon_closed = "emergency"
	icon_opened = "emergencyopen"

/obj/structure/closet/emcloset/legacy

/obj/structure/closet/firecloset
	name = "Fire Closet"
	desc = "A bulky (yet mobile) closet. Comes with supplies to fight fire."
	icon_state = "firecloset"
	icon_closed = "firecloset"
	icon_opened = "fireclosetopen"

/obj/structure/closet/hydrant //wall mounted fire closet
	name = "Fire Closet"
	desc = "A wall mounted closet which comes with supplies to fight fire."
	icon_state = "hydrant"
	icon_closed = "hydrant"
	icon_opened = "hydrant_open"
	anchored = 1
	density = 0
	wall_mounted = 1

/obj/structure/closet/medical_wall //wall mounted medical closet
	name = "First Aid Closet"
	desc = "A wall mounted closet which should have some first aid."
	icon_state = "medical_wall"
	icon_closed = "medical_wall"
	icon_opened = "medical_wall_open"
	anchored = 1
	density = 0
	wall_mounted = 1

/obj/structure/closet/toolcloset
	name = "Tool Closet"
	desc = "A bulky (yet mobile) closet. Contains tools."
	icon_state = "toolcloset"
	icon_closed = "toolcloset"
	icon_opened = "toolclosetopen"

/obj/structure/closet/jcloset
	name = "Custodial Closet"
	desc = "A bulky (yet mobile) closet. Contains the janitor's gear."

/obj/structure/closet/jcloset2
	name = "Cleaner's Closet"
	desc = "A bulky (yet mobile) closet. Contains various items for cleaning."

/obj/structure/closet/lawcloset
	name = "Legal Closet"
	desc = "A bulky (yet mobile) closet. Comes with lawyer apparel and items."

/obj/structure/closet/coffin
	name = "coffin"
	desc = "A burial receptacle for the dearly departed."
	icon_state = "coffin"
	icon_closed = "coffin"
	icon_opened = "coffin_open"

/obj/structure/closet/bombcloset
	name = "EOD closet"
	desc = "A bulky (yet mobile) closet. Comes prestocked with a level 4 bombsuit."
	icon_state = "bombsuit"
	icon_closed = "bombsuit"
	icon_opened = "bombsuitopen"

/obj/structure/closet/bombclosetsecurity
	name = "EOD closet"
	desc = "A bulky (yet mobile) closet. Comes prestocked with a level 4 bombsuit."
	icon_state = "bombsuitsec"
	icon_closed = "bombsuitsec"
	icon_opened = "bombsuitsecopen"

/obj/structure/closet/l3closet
	name = "Level 3 Biohazard Suit"
	desc = "A bulky (yet mobile) closet. Comes prestocked with level 3 biohazard gear for emergencies."
	icon_state = "bio"
	icon_closed = "bio"
	icon_opened = "bioopen"

/obj/structure/closet/l3closet/general
	name = "Level 3 Biohazard Suit"
	desc = "A bulky (yet mobile) closet. Comes prestocked with level 3 biohazard gear for emergencies."
	icon_state = "bio_general"
	icon_closed = "bio_general"
	icon_opened = "bio_generalopen"

/obj/structure/closet/l3closet/virology
	name = "Level 3 Biohazard Suit"
	desc = "A bulky (yet mobile) closet. Comes prestocked with level 3 biohazard gear for emergencies."
	icon_state = "bio_virology"
	icon_closed = "bio_virology"
	icon_opened = "bio_virologyopen"

/obj/structure/closet/l3closet/security
	name = "Level 3 Biohazard Suit"
	desc = "A bulky (yet mobile) closet. Comes prestocked with level 3 biohazard gear for emergencies."
	icon_state = "bio_security"
	icon_closed = "bio_security"
	icon_opened = "bio_securityopen"

/obj/structure/closet/l3closet/janitor
	name = "Level 3 Biohazard Suit"
	desc = "A bulky (yet mobile) closet. Comes prestocked with level 3 biohazard gear for emergencies."
	icon_state = "bio_janitor"
	icon_closed = "bio_janitor"
	icon_opened = "bio_janitoropen"

/obj/structure/closet/l3closet/scientist
	name = "Level 3 Biohazard Suit"
	desc = "A bulky (yet mobile) closet. Comes prestocked with level 3 biohazard gear for emergencies."
	icon_state = "bio_scientist"
	icon_closed = "bio_scientist"
	icon_opened = "bio_scientistopen"

/obj/structure/closet/syndicate
	name = "Weapons Closet"
	desc = "Why is this here?"
	icon_state = "syndicate"
	icon_closed = "syndicate"
	icon_opened = "syndicateopen"

/obj/structure/closet/syndicate/personal
	name = "Gear Closet"
	desc = "Gear preperations closet."

/obj/structure/closet/syndicate/nuclear
	name = "Nuclear Closet"
	desc = "Nuclear preperations closet."

	// Inserting the gimmick clothing stuff here for generic items, IE Tacticool stuff


/obj/structure/closet/gimmick
	name = "Administrative Supply Closet"
	icon_state = "syndicate1"
	icon_closed = "syndicate1"
	icon_opened = "syndicate1open"
	desc = "Closet of things that have no right being here."
	anchored = 0

/obj/structure/closet/gimmick/russian
	name = "Russian Surplus"
	icon_state = "syndicate1"
	icon_closed = "syndicate1"
	icon_opened = "syndicate1open"
	desc = "Russian Surplus Closet"

/obj/structure/closet/gimmick/tacticool
	name = "Tacticool Gear"
	icon_state = "syndicate1"
	icon_closed = "syndicate1"
	icon_opened = "syndicate1open"
	desc = "Tacticool Gear Closet"

/obj/structure/closet/thunderdome
	desc = "Everything you need!"
	icon_state = "syndicate"
	icon_closed = "syndicate"
	icon_opened = "syndicateopen"
	name = "Thunderdome closet"
	anchored = 1

/obj/structure/closet/thunderdome/tdred
	desc = "Everything you need!"
	icon_state = "syndicate"
	icon_closed = "syndicate"
	icon_opened = "syndicateopen"
	name = "Thunderdome closet"

/obj/structure/closet/thunderdome/tdgreen
	desc = "Everything you need!"
	icon_state = "syndicate1"
	icon_closed = "syndicate1"
	icon_opened = "syndicate1open"
	name = "Thunderdome closet"

/obj/structure/closet/malf/suits
	desc = "Gear preparations closet"
	icon_state = "syndicate"
	icon_closed = "syndicate"
	icon_opened = "syndicateopen"

/obj/structure/closet/wardrobe
	desc = "A bulky (yet mobile) wardrobe closet. Comes prestocked with 6 changes of clothes."
	name = "Wardrobe"
	icon_state = "blue"
	icon_closed = "blue"

/obj/structure/closet/wardrobe/black
	name = "Black Wardrobe"
	desc = "Contains black jumpsuits."
	icon_state = "black"
	icon_closed = "black"

/obj/structure/closet/wardrobe/chaplain_black
	name = "Chaplain Wardrobe"
	desc = "Closet of basic chaplain clothes."
	icon_state = "black"
	icon_closed = "black"

/obj/structure/closet/wardrobe/green
	name = "Green Wardrobe"
	desc = "Contains green jumpsuits."
	icon_state = "green"
	icon_closed = "green"

/obj/structure/closet/wardrobe/mixed
	name = "Mixed Wardrobe"
	desc = "This appears to contain several different sets of clothing."
	icon_state = "mixed"
	icon_closed = "mixed"

/obj/structure/closet/wardrobe/orange
	name = "Prisoner's Wardrobe"
	desc = "Contains orange jumpsuits."
	icon_state = "orange"
	icon_closed = "orange"

/obj/structure/closet/wardrobe/pink
	name = "Pink Wardrobe"
	desc = "Contains pink jumpsuits."
	icon_state = "pink"
	icon_closed = "pink"

/obj/structure/closet/wardrobe/red
	name = "Security Wardrobe"
	desc = "Contains security officer jumpsuits."
	icon_state = "red"
	icon_closed = "red"

/obj/structure/closet/wardrobe/warden
	name = "Warden's Wardrobe"
	desc = "Contains the warden's security uniform."
	icon_state = "red"
	icon_closed = "red"

/obj/structure/closet/wardrobe/hos
	name = "Head of Security's Wardrobe"
	desc = "Contains the Head of Security's uniform."
	icon_state = "red"
	icon_closed = "red"

/obj/structure/closet/wardrobe/hop
	name = "Head of Personnel's Wardrobe"
	desc = "Contains the Head of Personnel's uniform."
	icon_state = "blue"
	icon_closed = "blue"

/obj/structure/closet/wardrobe/white
	name = "White Wardrobe"
	desc = "Contains white jumpsuits."
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/toxins_white
	name = "Toxins Wardrobe"
	desc = "Contains toxins jumpsuits."
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/genetics_white
	name = "Genetics Wardrobe"
	desc = "Contains genetics jumpsuits."
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/medic_white
	name = "Doctor's Wardrobe"
	desc = "Contains medical jumpsuits."
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/chemistry_white
	name = "Chemistry Wardrobe"
	desc = "Contains chemistry jumpsuits."
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/nurse
	name = "Nurse's Wardrobe"
	desc = "Contains nurse uniforms."
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/cmo
	name = "Chief Medical Officer's Wardrobe"
	desc = "Contains the Chief Medical Officer's clothing."
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/rd
	name = "Research Director's Wardrobe"
	desc = "Contains the Research Director's clothing."
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/scientist
	name = "Scientist's Wardrobe"
	desc = "Contains the scientist's clothing."
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/virology_white
	name = "Virology Wardrobe"
	desc = "Contains virologist jumpsuits."
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/yellow
	name = "Yellow Wardrobe"
	desc = "Contains yellow jumpsuits."
	icon_state = "yellow"
	icon_closed = "yellow"

/obj/structure/closet/wardrobe/engineering_yellow
	name = "Engineering Wardrobe"
	desc = "Contains engineering jumpsuits."
	icon_state = "yellow"
	icon_closed = "yellow"

/obj/structure/closet/wardrobe/robotics_yellow
	name = "Robotics Wardrobe"
	desc = "Contains robotics jumpsuits."
	icon_state = "yellow"
	icon_closed = "yellow"

/obj/structure/closet/wardrobe/atmospherics_yellow
	name = "Atmospherics Wardrobe"
	desc = "Contains atmospheric jumpsuits."
	icon_state = "yellow"
	icon_closed = "yellow"

/obj/structure/closet/wardrobe/grey
	name = "Grey Wardrobe"
	desc = "Contains grey jumpsuits."
	icon_state = "grey"
	icon_closed = "grey"

/obj/structure/closet/wardrobe/bartender_black
	name = "Bartender's Wardrobe"
	desc = "Closet of basic bartending clothes."
	icon_state = "black"
	icon_closed = "black"

/obj/structure/closet/wardrobe/chef_white
	name = "Chef's Wardrobe"
	desc = "Contains chef jumpsuits."
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/hydro_green
	name = "Hydroponics Wardrobe"
	desc = "Contains botanist jumpsuits."
	icon_state = "green"
	icon_closed = "green"

/obj/structure/closet/wardrobe/librarian_red
	name = "Librarian's Wardrobe"
	desc = "Contains librarian jumpsuits."
	icon_state = "red"
	icon_closed = "red"

/obj/structure/closet/wardrobe/cargo_yellow
	name = "Cargo Tech's Wardrobe"
	desc = "Contains cargo tech jumpsuits."
	icon_state = "yellow"
	icon_closed = "yellow"

/obj/structure/closet/wardrobe/qm_yellow
	name = "Quartermaster's Wardrobe"
	desc = "Contains quartermaster jumpsuits."
	icon_state = "yellow"
	icon_closed = "yellow"



/obj/structure/closet/secure_closet
	desc = "An immobile card-locked storage closet."
	name = "Security Locker"
	icon = 'closet.dmi'
	icon_state = "secure1"
	density = 1
	opened = 0
	var/locked = 1
	var/broken = 0
	var/large = 1
	icon_closed = "secure"
	var/icon_locked = "secure1"
	icon_opened = "secureopen"
	var/icon_broken = "securebroken"
	var/icon_off = "secureoff"
	wall_mounted = 0 //never solid (You can always pass over it)
	health = 200

/obj/structure/closet/secure_closet/medical_wall
	name = "First Aid Closet"
	desc = "A wall mounted closet which --should-- contain medical supplies."
	icon_state = "medical_wall_locked"
	icon_closed = "medical_wall_unlocked"
	icon_locked = "medical_wall_locked"
	icon_opened = "medical_wall_open"
	icon_broken = "medical_wall_spark"
	icon_off = "medical_wall_off"
	anchored = 1
	density = 0
	wall_mounted = 1
	req_access = list(access_medical)

/obj/structure/closet/secure_closet/personal
	desc = "The first card swiped gains control."
	name = "Personal Closet"

/obj/structure/closet/secure_closet/personal/patient
	name = "Patient's closet"

/obj/structure/closet/secure_closet/personal/cabinet
	icon_state = "cabinetdetective_locked"
	icon_closed = "cabinetdetective"
	icon_locked = "cabinetdetective_locked"
	icon_opened = "cabinetdetective_open"
	icon_broken = "cabinetdetective_broken"
	icon_off = "cabinetdetective_broken"

/obj/structure/closet/secure_closet/kitchen
	name = "Kitchen Cabinet"
	req_access = list(access_kitchen)

/obj/structure/closet/secure_closet/kitchen/mining
	req_access = list()

/obj/structure/closet/secure_closet/meat
	name = "Meat Fridge"
	icon_state = "fridge1"
	icon_closed = "fridge"
	icon_locked = "fridge1"
	icon_opened = "fridgeopen"
	icon_broken = "fridgebroken"
	icon_off = "fridge1"

/obj/structure/closet/secure_closet/fridge
	name = "Refrigerator"
	icon_state = "fridge1"
	icon_closed = "fridge"
	icon_locked = "fridge1"
	icon_opened = "fridgeopen"
	icon_broken = "fridgebroken"
	icon_off = "fridge1"

/obj/structure/closet/secure_closet/money_freezer
	name = "Freezer"
	icon_state = "fridge1"
	icon_closed = "fridge"
	icon_locked = "fridge1"
	icon_opened = "fridgeopen"
	icon_broken = "fridgebroken"
	icon_off = "fridge1"
	req_access = list(access_heads_vault)

/obj/structure/closet/secure_closet/personal/patient
	name = "patient's closet"

/obj/structure/closet/secure_closet/wall
	name = "wall locker"
	req_access = list(access_security)
	icon_state = "wall-locker1"
	density = 1
	icon_closed = "wall-locker"
	icon_locked = "wall-locker1"
	icon_opened = "wall-lockeropen"
	icon_broken = "wall-lockerbroken"
	icon_off = "wall-lockeroff"

	//too small to put a man in
	large = 0