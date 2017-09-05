/proc/get_archeological_find_by_findtype(var/find_type)
	for(var/T in typesof(/obj/item/weapon/archaeological_find))
		var/obj/item/weapon/archaeological_find/F = T
		if(find_type == initial(F.find_type))
			return T
	return /obj/item/weapon/archaeological_find

/obj/item/weapon/archaeological_find
	name = "object"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "unknown2"
	var/find_type = ARCHAEO_UNKNOWN
	var/item_type = "object"
	var/apply_prefix = 1
	var/apply_material_decorations = 1
	var/apply_image_decorations = 0
	var/additional_desc

/obj/item/weapon/archaeological_find/Initialize()
	. = ..()
	var/obj/item/I = spawn_item()

	var/source_material = ""
	var/material_descriptor = ""
	if(prob(40))
		material_descriptor = pick("rusted ","dusty ","archaic ","fragile ")
	source_material = pick("cordite","quadrinium",DEFAULT_WALL_MATERIAL,"titanium","aluminium","ferritic-alloy","plasteel","duranium")

	var/decorations = ""
	if(apply_material_decorations)
		source_material = pick("cordite","quadrinium",DEFAULT_WALL_MATERIAL,"titanium","aluminium","ferritic-alloy","plasteel","duranium")
		desc = "A [material_descriptor ? "[material_descriptor] " : ""][item_type] made of [source_material], all craftsmanship is of [pick("the lowest","low","average","high","the highest")] quality."

		var/list/descriptors = list()
		if(prob(30))
			descriptors.Add("is encrusted with [pick("","synthetic ","multi-faceted ","uncut ","sparkling ") + pick("rubies","emeralds","diamonds","opals","lapiz lazuli")]")
		if(prob(30))
			descriptors.Add("is studded with [pick("gold","silver","aluminium","titanium")]")
		if(prob(30))
			descriptors.Add("is encircled with bands of [pick("quadrinium","cordite","ferritic-alloy","plasteel","duranium")]")
		if(prob(30))
			descriptors.Add("menaces with spikes of [pick("solid phoron","uranium","white pearl","black steel")]")
		if(descriptors.len > 0)
			decorations = "It "
			for(var/index=1, index <= descriptors.len, index++)
				if(index > 1)
					if(index == descriptors.len)
						decorations += " and "
					else
						decorations += ", "
				decorations += descriptors[index]
			decorations += "."
		if(decorations)
			desc += " " + decorations

	var/engravings = ""
	if(apply_image_decorations)
		var/obj/effect/overmap/sector/exoplanet/E = map_sectors["[z]"]
		if(istype(E))
			engravings = E.get_engravings()
		else
			engravings = "[pick("Engraved","Carved","Etched")] on the item is [pick("an image of","a frieze of","a depiction of")] \
			[pick("an alien humanoid","an amorphic blob","a short, hairy being","a rodent-like creature","a robot","a primate","a reptilian alien","an unidentifiable object","a statue","a starship","unusual devices","a structure")] \
			[pick("surrounded by","being held aloft by","being struck by","being examined by","communicating with")] \
			[pick("alien humanoids","amorphic blobs","short, hairy beings","rodent-like creatures","robots","primates","reptilian aliens")]"
			if(prob(50))
				engravings += ", [pick("they seem to be enjoying themselves","they seem extremely angry","they look pensive","they are making gestures of supplication","the scene is one of subtle horror","the scene conveys a sense of desperation","the scene is completely bizarre")]"
			engravings += "."

		if(desc)
			desc += " "
		desc += engravings

	if(apply_prefix)
		name = "[pick("strange","ancient","alien","")] [item_type]"
	else
		name = item_type

	if(desc)
		desc += " "
	desc += additional_desc
	if(!desc)
		desc = "This item is completely [pick("alien","bizarre")]."

	//icon and icon_state should have already been set
	I.name = name
	I.desc = desc

	if(prob(5))
		I.talking_atom = new(I)

	return INITIALIZE_HINT_QDEL

/obj/item/weapon/archaeological_find/proc/spawn_item()
	var/obj/item/weapon/material/kitchen/utensil/fork/F = new(loc)
	F.icon = 'icons/obj/xenoarchaeology.dmi'
	F.icon_state = "unknown[rand(1,4)]"
	return F

/obj/item/weapon/archaeological_find/bowl
	find_type = ARCHAEO_BOWL
	item_type = "bowl"
	icon_state = "bowl"
	apply_image_decorations = 1

/obj/item/weapon/archaeological_find/bowl/spawn_item()
	var/obj/item/weapon/reagent_containers/R
	if(prob(33)) 
		R = new /obj/item/weapon/reagent_containers/glass/replenishing(loc)
	else
		R = new /obj/item/weapon/reagent_containers/glass/beaker(loc)
	R.icon = 'icons/obj/xenoarchaeology.dmi'
	R.icon_state = "bowl"
	if(prob(20))
		additional_desc = "There appear to be [pick("dark","faintly glowing","pungent","bright")] [pick("red","purple","green","blue")] stains inside."
	return R

/obj/item/weapon/archaeological_find/bowl/urn
	item_type = "urn"
	icon_state = "urn"

/obj/item/weapon/archaeological_find/bowl/urn/spawn_item()
	var/obj/item/I = ..()
	I.icon_state = "urn"
	if(prob(20))
		additional_desc = "It [pick("whispers faintly","makes a quiet roaring sound","whistles softly","thrums quietly","throbs")] if you put it to your ear."
	else
		additional_desc = null

/obj/item/weapon/archaeological_find/cutlery
	item_type = "cutlery"
	find_type = ARCHAEO_CUTLERY

/obj/item/weapon/archaeological_find/cutlery/spawn_item()
	var/obj/item/new_item
	if(prob(25))
		new_item = new /obj/item/weapon/material/kitchen/utensil/fork(loc)
	else if(prob(50))
		new_item = new /obj/item/weapon/material/kitchen/utensil/knife(loc)
	else
		new_item = new /obj/item/weapon/material/kitchen/utensil/spoon(loc)
	additional_desc = "[pick("It's like no [item_type] you've ever seen before",\
	"It's a mystery how anyone is supposed to eat with this",\
	"You wonder what the creator's mouth was shaped like")]."
	return new_item

/obj/item/weapon/archaeological_find/statuette
	item_type = "statuette"
	icon_state = "statuette"
	find_type = ARCHAEO_STATUETTE

/obj/item/weapon/archaeological_find/statuette/spawn_item()
	var/obj/item/new_item
	if(prob(25))
		new_item = new /obj/item/weapon/vampiric(loc)
	else
		new_item = new(loc)
	new_item.name = "statuette"
	new_item.icon = 'icons/obj/xenoarchaeology.dmi'
	new_item.icon_state = "statuette"

	additional_desc = "It depicts a [pick("small","ferocious","wild","pleasing","hulking")] \
	[pick("alien figure","rodent-like creature","reptilian alien","primate","unidentifiable object")] \
	[pick("performing unspeakable acts","posing heroically","in a fetal position","cheering","sobbing","making a plaintive gesture","making a rude gesture")]."
	return new_item

/obj/item/weapon/archaeological_find/instrument
	item_type = "instrument"
	icon_state = "instrument"
	find_type = ARCHAEO_INSTRUMENT
	
/obj/item/weapon/archaeological_find/instrument/spawn_item()
	var/obj/item/new_item = new(loc)
	new_item.name = "instrument"
	new_item.icon = 'icons/obj/xenoarchaeology.dmi'
	new_item.icon_state = "instrument"
	if(prob(30))
		apply_image_decorations = 1
		additional_desc = "[pick("You're not sure how anyone could have played this",\
		"You wonder how many mouths the creator had",\
		"You wonder what it sounds like",\
		"You wonder what kind of music was made with it")]."
	return new_item

/obj/item/weapon/archaeological_find/knife
	item_type = "knife"
	find_type = ARCHAEO_KNIFE
	
/obj/item/weapon/archaeological_find/knife/spawn_item()
	item_type = "[pick("bladed knife","serrated blade","sharp cutting implement")]"
	var/obj/item/new_item = new /obj/item/weapon/material/knife(loc)
	additional_desc = "[pick("It doesn't look safe.",\
	"It looks wickedly jagged",\
	"There appear to be [pick("dark red","dark purple","dark green","dark blue")] stains along the edges")]."
	return new_item

/obj/item/weapon/archaeological_find/coin
	item_type = "coin"
	find_type = ARCHAEO_COIN
	apply_prefix = 0
	apply_material_decorations = 0
	apply_image_decorations = 1

/obj/item/weapon/archaeological_find/coin/spawn_item()
	var/obj/item/weapon/coin/C = pick(subtypesof(/obj/item/weapon/coin))
	C = new C(loc)
	return C

/obj/item/weapon/archaeological_find/trap
	item_type = "trap"
	icon = 'icons/obj/items.dmi'
	icon_state = "beartrap0"
	find_type = ARCHAEO_BEARTRAP
	apply_prefix = 0

/obj/item/weapon/archaeological_find/trap/spawn_item()
	item_type = "[pick("wicked","evil","byzantine","dangerous")] looking [pick("device","contraption","thing","trap")]"
	var/obj/item/new_item = new /obj/item/weapon/beartrap(loc)
	additional_desc = "[pick("It looks like it could take a limb off",\
	"Could be some kind of animal trap",\
	"There appear to be [pick("dark red","dark purple","dark green","dark blue")] stains along part of it")]."
	return new_item

/obj/item/weapon/archaeological_find/container
	item_type = "container"
	icon_state = "box"
	find_type = ARCHAEO_BOX

/obj/item/weapon/archaeological_find/container/spawn_item()
	var/obj/item/weapon/storage/box/new_box = new(loc)
	new_box.icon = 'icons/obj/xenoarchaeology.dmi'
	new_box.max_w_class = pick(ITEM_SIZE_TINY,2;ITEM_SIZE_SMALL,3;ITEM_SIZE_NORMAL,4;ITEM_SIZE_LARGE)
	var/storage_amount = base_storage_cost(new_box.max_w_class)
	new_box.max_storage_space = rand(storage_amount, storage_amount * 10)
	new_box.icon_state = "box"
	if(prob(30))
		apply_image_decorations = 1
	return new_box

/obj/item/weapon/archaeological_find/tank
	item_type = "tank"
	find_type = ARCHAEO_GASTANK

/obj/item/weapon/archaeological_find/tank/spawn_item()
	item_type = "[pick("cylinder","tank","chamber")]"
	var/obj/item/weapon/tank/new_item = new/obj/item/weapon/tank(loc)
	new_item.air_contents.gas.Cut()
	new_item.air_contents.adjust_gas(pick(gas_data.gases),15)
	additional_desc = "It [pick("gloops","sloshes")] slightly when you shake it."
	return new_item

/obj/item/weapon/archaeological_find/tool
	item_type = "tool"
	find_type = ARCHAEO_TOOL

/obj/item/weapon/archaeological_find/tool/spawn_item()
	var/obj/item/weapon/new_item
	if(prob(25))
		new_item = new /obj/item/weapon/wrench(loc)
	else if(prob(25))
		new_item = new /obj/item/weapon/crowbar(loc)
	else
		new_item = new /obj/item/weapon/screwdriver(loc)
	new_item.icon = 'icons/obj/xenoarchaeology.dmi'
	new_item.icon_state = "unkown[rand(1,4)]"
	additional_desc = "[pick("It doesn't look safe.",\
	"You wonder what it was used for",\
	"There appear to be [pick("dark red","dark purple","dark green","dark blue")] stains on it")]."
	return new_item

/obj/item/weapon/archaeological_find/material
	item_type = "material lump"
	find_type = ARCHAEO_METAL
	apply_material_decorations = 0

/obj/item/weapon/archaeological_find/material/spawn_item()
	var/list/possible_spawns = list()
	possible_spawns += /obj/item/stack/material/steel
	possible_spawns += /obj/item/stack/material/plasteel
	possible_spawns += /obj/item/stack/material/glass
	possible_spawns += /obj/item/stack/material/glass/reinforced
	possible_spawns += /obj/item/stack/material/phoron
	possible_spawns += /obj/item/stack/material/gold
	possible_spawns += /obj/item/stack/material/silver
	possible_spawns += /obj/item/stack/material/uranium
	possible_spawns += /obj/item/stack/material/sandstone
	possible_spawns += /obj/item/stack/material/silver
	var/new_type = pick(possible_spawns)
	var/obj/item/stack/material/new_item = new new_type(loc)
	new_item.amount = rand(5,45)
	return new_item

/obj/item/weapon/archaeological_find/crystal
	item_type = "crystal"
	icon_state = "Green lump"
	find_type = ARCHAEO_CRYSTAL
	apply_prefix = 0
	apply_material_decorations = 0

/obj/item/weapon/archaeological_find/crystal/spawn_item()
	var/obj/item/new_item
	if(prob(25))
		new_item = new /obj/item/device/soulstone(loc)
	else
		new_item = new(loc)
	apply_image_decorations = 1
	additional_desc = pick("It shines faintly as it catches the light.","It appears to have a faint inner glow.","It seems to draw you inward as you look it at.","Something twinkles faintly as you look at it.","It's mesmerizing to behold.")

	new_item.icon = 'icons/obj/xenoarchaeology.dmi'
	if(prob(25))
		item_type = "smooth green crystal"
		new_item.icon_state = "Green lump"
	else if(prob(33))
		item_type = "irregular purple crystal"
		new_item.icon_state = "Phazon"
	else
		item_type = "rough red crystal"
		new_item.icon_state = "changerock"

/obj/item/weapon/archaeological_find/blade
	item_type = "blade"
	find_type = ARCHAEO_CULTBLADE
	apply_prefix = 0
	apply_material_decorations = 0
	apply_image_decorations = 0

/obj/item/weapon/archaeological_find/blade/spawn_item()
	return new /obj/item/weapon/melee/cultblade(loc)
	
/obj/item/weapon/archaeological_find/beacon
	item_type = "device"
	find_type = ARCHAEO_TELEBEACON

/obj/item/weapon/archaeological_find/beacon/spawn_item()
	var/obj/item/device/radio/beacon/new_item = new(loc)
	new_item.icon = 'icons/obj/xenoarchaeology.dmi'
	new_item.icon_state = "unknown[rand(1,4)]"
	new_item.desc = ""
	return new_item

/obj/item/weapon/archaeological_find/sword
	item_type = "sword"
	find_type = ARCHAEO_CLAYMORE

/obj/item/weapon/archaeological_find/sword/spawn_item()
	return new /obj/item/weapon/material/sword(loc)

/obj/item/weapon/archaeological_find/robes
	item_type = "garments"
	find_type = ARCHAEO_CULTROBES

/obj/item/weapon/archaeological_find/robes/spawn_item()
	var/list/possible_spawns = list(/obj/item/clothing/head/culthood,
	/obj/item/clothing/head/culthood/magus,
	/obj/item/clothing/head/culthood/alt,
	/obj/item/clothing/head/helmet/space/cult)
	var/new_type = pick(possible_spawns)
	return new new_type(loc)

/obj/item/weapon/archaeological_find/katana
	item_type = "blade"
	find_type = ARCHAEO_CLAYMORE

/obj/item/weapon/archaeological_find/katana/spawn_item()
	return new /obj/item/weapon/material/sword/katana(loc)

/obj/item/weapon/archaeological_find/parts
	item_type = "parts"
	find_type = ARCHAEO_STOCKPARTS
	apply_material_decorations = 0

/obj/item/weapon/archaeological_find/parts/spawn_item()
	var/list/possible_spawns = subtypesof(/obj/item/weapon/stock_parts)
	possible_spawns -= /obj/item/weapon/stock_parts/subspace
	var/new_type = pick(possible_spawns)
	return new new_type(loc)
	
/obj/item/weapon/archaeological_find/laser
	item_type = "gun"
	icon_state = "egun1"
	find_type = ARCHAEO_LASER

/obj/item/weapon/archaeological_find/laser/spawn_item()
	var/spawn_type = pick(\
	/obj/item/weapon/gun/energy/laser/practice/xenoarch,\
	/obj/item/weapon/gun/energy/laser/xenoarch,\
	/obj/item/weapon/gun/energy/xray/xenoarch,\
	/obj/item/weapon/gun/energy/captain/xenoarch)
	var/obj/item/weapon/gun/energy/new_gun =  new spawn_type(loc)
	new_gun.icon_state = "egun[rand(1,6)]"
	new_gun.desc = "This is an antique energy weapon, you're not sure if it will fire or not."
	//10% chance to have an unchargeable cell
	//15% chance to gain a random amount of starting energy, otherwise start with an empty cell

	if(prob(10))
		new_gun.power_supply.maxcharge = 0
	if(prob(15))
		new_gun.power_supply.charge = rand(0, new_gun.power_supply.maxcharge)
	else
		new_gun.power_supply.charge = 0
	return new_gun
	
/obj/item/weapon/archaeological_find/gun
	item_type = "gun"
	icon_state = "gun1"
	find_type = ARCHAEO_GUN

/obj/item/weapon/archaeological_find/gun/spawn_item()
	var/obj/item/weapon/gun/projectile/revolver/new_gun =  new(loc)
	new_gun.icon = 'icons/obj/xenoarchaeology.dmi'
	new_gun.icon_state = "gun[rand(1,6)]"
	new_gun.desc = "This is an antique weapon, you're not sure if it will fire or not."
	//33% chance to be able to reload the gun with human ammunition
	if(prob(66))
		new_gun.caliber = "999"
	//33% chance to fill it with a random amount of bullets
	new_gun.max_shells = rand(1,12)
	new_gun.loaded.Cut()
	if(prob(33))
		var/num_bullets = rand(1, new_gun.max_shells)
		for(var/i = 1 to num_bullets)
			var/obj/item/ammo_casing/A = new new_gun.ammo_type(new_gun)
			new_gun.loaded += A
			if(A.caliber != new_gun.caliber)
				A.caliber = new_gun.caliber
				A.desc = "A bullet casing of unknown caliber."
	return new_gun

/obj/item/weapon/archaeological_find/fossil
	item_type = "bones"
	icon_state = "bone"
	find_type = ARCHAEO_FOSSIL
	apply_prefix = 0
	apply_image_decorations = 0
	apply_material_decorations = 0

/obj/item/weapon/archaeological_find/fossil/spawn_item()
	var/list/candidates = list(/obj/item/weapon/fossil/bone=9,/obj/item/weapon/fossil/skull=3,
	/obj/item/weapon/fossil/skull/horned=2)
	var/spawn_type = pickweight(candidates)
	return new spawn_type(loc)

/obj/item/weapon/archaeological_find/shell
	item_type = "shell"
	icon_state = "shell"
	find_type = ARCHAEO_SHELL
	apply_prefix = 0
	apply_image_decorations = 0
	apply_material_decorations = 0

/obj/item/weapon/archaeological_find/shell/spawn_item()
	if(prob(10))
		apply_image_decorations = 1
	return new /obj/item/weapon/fossil/shell(loc)

/obj/item/weapon/archaeological_find/plant
	item_type = "fossilized plant"
	icon_state = "plant1"
	find_type = ARCHAEO_PLANT
	apply_prefix = 0
	apply_image_decorations = 0
	apply_material_decorations = 0

/obj/item/weapon/archaeological_find/plant/spawn_item()
	return new /obj/item/weapon/fossil/plant(loc)

/obj/item/weapon/archaeological_find/remains
	item_type = "remains"
	icon = 'icons/effects/blood.dmi'
	icon_state = "remains"
	find_type = ARCHAEO_REMAINS_HUMANOID
	apply_image_decorations = 0
	apply_material_decorations = 0
	var/list/descs = list("They appear almost human.",\
	"They are contorted in a most gruesome way.",\
	"They look almost peaceful.",\
	"The bones are yellowing and old, but remarkably well preserved.",\
	"The bones are scored by numerous burns and partially melted.",\
	"The are battered and broken, in some cases less than splinters are left.",\
	"The mouth is wide open in a death rictus, the victim would appear to have died screaming.")

/obj/item/weapon/archaeological_find/remains/spawn_item()
	item_type = "humanoid [pick("remains","skeleton")]"
	if(prob(5))
		apply_image_decorations = 1
	var/obj/item/I = new(loc)
	I.icon = icon
	I.icon_state = icon_state
	additional_desc = pick(descs)
	return I

/obj/item/weapon/archaeological_find/remains/robot
	icon_state = "remainsrobot"
	find_type = ARCHAEO_REMAINS_ROBOT
	descs = list("Almost mistakeable for the remains of a modern cyborg.",\
			"They are barely recognisable as anything other than a pile of waste metals.",\
			"It looks like the battered remains of an ancient robot chassis.",\
			"The chassis is rusting and old, but remarkably well preserved.",\
			"The chassis is scored by numerous burns and partially melted.",\
			"The chassis is battered and broken, in some cases only chunks of metal are left.",\
			"A pile of wires and crap metal that looks vaguely robotic.")

/obj/item/weapon/archaeological_find/remains/robot/spawn_item()
	. = ..()
	item_type = "[pick("mechanical","robotic","cyborg")] [pick("remains","chassis","debris")]"

/obj/item/weapon/archaeological_find/remains/xeno
	icon_state = "remainsxeno"
	find_type = ARCHAEO_REMAINS_ROBOT
	descs = list("It looks vaguely reptilian, but with more teeth.",\
			"They are faintly unsettling.",\
			"There is a faint aura of unease about them.",\
			"The bones are yellowing and old, but remarkably well preserved.",\
			"The bones are scored by numerous burns and partially melted.",\
			"The are battered and broken, in some cases less than splinters are left.",\
			"This creature would have been twisted and monstrous when it was alive.",\
			"It doesn't look human.")

/obj/item/weapon/archaeological_find/remains/xeno/spawn_item()
	. = ..()
	item_type = "alien [pick("remains","skeleton")]"

/obj/item/weapon/archaeological_find/mask
	item_type = "mask"
	find_type = ARCHAEO_GASMASK

/obj/item/weapon/archaeological_find/mask/spawn_item()
	var/obj/item/clothing/mask/gas/new_item
	if(prob(25))
		new_item = new /obj/item/clothing/mask/gas/poltergeist(loc)
	else
		new_item = new /obj/item/clothing/mask/gas(loc)
	return new_item