/obj/item/natural_weapon
	name = "natural weapons"
	gender = PLURAL
	attack_verb = list("attacked")
	force = 0
	damtype = DAMAGE_BRUTE
	canremove = FALSE
	obj_flags = OBJ_FLAG_CONDUCTIBLE //for intent of shocking checks, they're right inside the animal
	var/show_in_message   // whether should we show up in attack message, e.g. 'urist has been bit with teeth by carp' vs 'urist has been bit by carp'

/obj/item/natural_weapon/attack_message_name()
	return show_in_message ? ..() : null

/obj/item/natural_weapon/can_embed()
	return FALSE

/obj/item/natural_weapon/bite
	name = "teeth"
	attack_verb = list("bitten")
	hitsound = 'sound/weapons/bite.ogg'
	force = 10
	sharp = TRUE

/obj/item/natural_weapon/bite/weak
	force = 5
	attack_verb = list("bitten", "nipped")

/obj/item/natural_weapon/bite/mouse
	force = 1
	attack_verb = list("nibbled")
	hitsound = null

/obj/item/natural_weapon/bite/strong
	force = 25

/obj/item/natural_weapon/claws
	name = "claws"
	attack_verb = list("mauled", "clawed", "slashed")
	force = 15
	sharp = TRUE
	edge = TRUE

/obj/item/natural_weapon/claws/strong
	force = 25

/obj/item/natural_weapon/claws/weak
	force = 5
	attack_verb = list("clawed", "scratched")

/obj/item/natural_weapon/hooves
	name = "hooves"
	attack_verb = list("kicked")
	force = 5

/obj/item/natural_weapon/punch
	name = "fists"
	attack_verb = list("punched")
	force = 10

/obj/item/natural_weapon/pincers
	name = "pincers"
	force = 10
	attack_verb = list("snipped", "pinched")

/obj/item/natural_weapon/drone_slicer
	name = "sharpened leg"
	gender = NEUTER
	attack_verb = list("sliced")
	force = 5
	damtype = DAMAGE_BRUTE
	edge = TRUE
	show_in_message = TRUE

/obj/item/natural_weapon/beak
	name = "beak"
	gender = NEUTER
	attack_verb = list("pecked", "jabbed", "poked")
	force = 5
	sharp = TRUE

/obj/item/natural_weapon/large
	force = 15

/obj/item/natural_weapon/giant
	force = 30
