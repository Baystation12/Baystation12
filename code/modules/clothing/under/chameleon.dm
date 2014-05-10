//*****************
//**Cham Jumpsuit**
//*****************

/obj/item/clothing/under/chameleon
//starts off as black
	name = "black jumpsuit"
	icon_state = "black"
	item_state = "bl_suit"
	item_color = "black"
	desc = "It's a plain jumpsuit. It seems to have a small dial on the wrist."
	origin_tech = "syndicate=3"
	var/list/clothing_choices = list()

	New()
		..()
		var/blocked = list(/obj/item/clothing/under/chameleon, /obj/item/clothing/under/cloud,
			/obj/item/clothing/under/golem, /obj/item/clothing/under/gimmick)//Prevent infinite loops and bad jumpsuits.
		for(var/U in typesof(/obj/item/clothing/under)-blocked)
			var/obj/item/clothing/under/V = new U
			src.clothing_choices[V.name] = U
		return

	emp_act(severity)
		name = "psychedelic"
		desc = "Groovy!"
		icon_state = "psyche"
		item_color = "psyche"
		update_icon()
		usr.update_inv_w_uniform()

	verb/change()
		set name = "Change Jumpsuit Appearance"
		set category = "Object"
		set src in usr

		var/picked = input("Select jumpsuit to change it to", "Chameleon Jumpsuit")as null|anything in clothing_choices
		if(!picked || !clothing_choices[picked])
			return
		var/newtype = clothing_choices[picked]
		var/obj/item/clothing/A = new newtype

		desc = null
		permeability_coefficient = 0.90

		desc = A.desc
		name = A.name
		icon_state = A.icon_state
		item_state = A.item_state
		item_color = A.item_color
		if(usr)
			usr.update_inv_w_uniform()	//so our overlays update.

//*****************
//**Chameleon Hat**
//*****************

/obj/item/clothing/head/chameleon
	name = "grey cap"
	icon_state = "greysoft"
	item_state = "greysoft"
	item_color = "grey"
	desc = "It looks like a plain hat, but upon closer inspection, there's an advanced holographic array installed inside. It seems to have a small dial inside."
	origin_tech = "syndicate=3"
	var/list/clothing_choices = list()

	New()
		..()
		var/blocked = list(/obj/item/clothing/head/chameleon,
			/obj/item/clothing/head/space/golem, /obj/item/clothing/head/justice,)//Prevent infinite loops and bad hats.
		for(var/U in typesof(/obj/item/clothing/head)-blocked)
			var/obj/item/clothing/head/V = new U
			src.clothing_choices[V.name] = U
		return

	emp_act(severity) //Because we don't have psych for all slots right now but still want a downside to EMP.  In this case your cover's blown.
		name = "grey cap"
		desc = "It's a baseball hat in a tasteful grey colour."
		icon_state = "greysoft"
		item_color = "grey"
		update_icon()
		usr.update_inv_head()

	verb/change()
		set name = "Change Hat/Helmet Appearance"
		set category = "Object"
		set src in usr

		var/picked = input("Select headwear to change it to", "Chameleon Hat")as null|anything in clothing_choices
		if(!picked || !clothing_choices[picked])
			return
		var/newtype = clothing_choices[picked]
		var/obj/item/clothing/A = new newtype

		desc = null
		permeability_coefficient = 0.90

		desc = A.desc
		name = A.name
		icon_state = A.icon_state
		item_state = A.item_state
		item_color = A.item_color
		flags_inv = A.flags_inv
		if(usr)
			usr.update_inv_head()	//so our overlays update.

//******************
//**Chameleon Suit**
//******************

/obj/item/clothing/suit/chameleon
	name = "armor"
	icon_state = "armor"
	item_state = "armor"
	desc = "It appears to be a vest of standard armor, except this is embedded with a hidden holographic cloaker, allowing it to change it's appearance, but offering no protection.. It seems to have a small dial inside."
	origin_tech = "syndicate=3"
	var/list/clothing_choices = list()

	New()
		..()
		var/blocked = list(/obj/item/clothing/suit/chameleon, /obj/item/clothing/suit/space/space_ninja,
			/obj/item/clothing/suit/golem, /obj/item/clothing/suit/suit, /obj/item/clothing/suit/cyborg_suit, /obj/item/clothing/suit/justice,
			/obj/item/clothing/suit/greatcoat)//Prevent infinite loops and bad suits.
		for(var/U in typesof(/obj/item/clothing/suit)-blocked)
			var/obj/item/clothing/suit/V = new U
			src.clothing_choices[V.name] = U
		return

	emp_act(severity) //Because we don't have psych for all slots right now but still want a downside to EMP.  In this case your cover's blown.
		name = "armor"
		desc = "An armored vest that protects against some damage."
		icon_state = "armor"
		item_color = "armor"
		update_icon()
		usr.update_inv_wear_suit()

	verb/change()
		set name = "Change Exosuit Appearance"
		set category = "Object"
		set src in usr

		var/picked = input("Select exosuit to change it to", "Chameleon Exosuit")as null|anything in clothing_choices
		if(!picked || !clothing_choices[picked])
			return
		var/newtype = clothing_choices[picked]
		var/obj/item/clothing/A = new newtype

		desc = null
		permeability_coefficient = 0.90

		desc = A.desc
		name = A.name
		icon_state = A.icon_state
		item_state = A.item_state
		item_color = A.item_color
		flags_inv = A.flags_inv
		if(usr)
			usr.update_inv_wear_suit()	//so our overlays update.

//*******************
//**Chameleon Shoes**
//*******************
/obj/item/clothing/shoes/chameleon
	name = "black shoes"
	icon_state = "black"
	item_state = "black"
	item_color = "black"
	desc = "They're comfy black shoes, with clever cloaking technology built in. It seems to have a small dial on the back of each shoe."
	origin_tech = "syndicate=3"
	var/list/clothing_choices = list()

	New()
		..()
		var/blocked = list(/obj/item/clothing/shoes/chameleon,
			/obj/item/clothing/shoes/golem, /obj/item/clothing/shoes/syndigaloshes, /obj/item/clothing/shoes/cyborg)//prevent infinite loops and bad shoes.
		for(var/U in typesof(/obj/item/clothing/shoes)-blocked)
			var/obj/item/clothing/shoes/V = new U
			src.clothing_choices[V.name] = U
		return

	emp_act(severity) //Because we don't have psych for all slots right now but still want a downside to EMP.  In this case your cover's blown.
		name = "black shoes"
		desc = "A pair of black shoes."
		icon_state = "black"
		item_state = "black"
		item_color = "black"
		update_icon()
		usr.update_inv_shoes()

	verb/change()
		set name = "Change Footwear Appearance"
		set category = "Object"
		set src in usr

		var/picked = input("Select shoes to change it to", "Chameleon Shoes")as null|anything in clothing_choices
		if(!picked || !clothing_choices[picked])
			return
		var/newtype = clothing_choices[picked]
		var/obj/item/clothing/A = new newtype

		desc = null
		permeability_coefficient = 0.90

		desc = A.desc
		name = A.name
		icon_state = A.icon_state
		item_state = A.item_state
		item_color = A.item_color
		if(usr)
			usr.update_inv_shoes()	//so our overlays update.

//**********************
//**Chameleon Backpack**
//**********************
/obj/item/weapon/storage/backpack/chameleon
	name = "backpack"
	icon_state = "backpack"
	item_state = "backpack"
	desc = "A backpack outfitted with cloaking tech. It seems to have a small dial inside, kept away from the storage."
	origin_tech = "syndicate=3"
	var/list/clothing_choices = list()

	New()
		..()
		var/blocked = list(/obj/item/weapon/storage/backpack/chameleon, /obj/item/weapon/storage/backpack/satchel/withwallet)
		for(var/U in typesof(/obj/item/weapon/storage/backpack)-blocked)//Prevent infinite loops and bad backpacks.
			var/obj/item/weapon/storage/backpack/V = new U
			src.clothing_choices[V.name] = U
		return

	emp_act(severity) //Because we don't have psych for all slots right now but still want a downside to EMP.  In this case your cover's blown.
		name = "backpack"
		desc = "You wear this on your back and put items into it."
		icon_state = "backpack"
		item_state = "backpack"
		update_icon()
		usr.update_inv_back()

	verb/change()
		set name = "Change Backpack Appearance"
		set category = "Object"
		set src in usr

		var/picked = input("Select backpack to change it to", "Chameleon Backpack")as null|anything in clothing_choices
		if(!picked || !clothing_choices[picked])
			return
		var/newtype = clothing_choices[picked]
		var/obj/item/weapon/storage/backpack/A = new newtype

		desc = null
		permeability_coefficient = 0.90

		desc = A.desc
		name = A.name
		icon_state = A.icon_state
		item_state = A.item_state
		item_color = A.item_color
		if(usr)
			usr.update_inv_back()	//so our overlays update.

//********************
//**Chameleon Gloves**
//********************

/obj/item/clothing/gloves/chameleon
	name = "black gloves"
	icon_state = "black"
	item_state = "bgloves"
	item_color = "brown"
	desc = "It looks like a pair of gloves, but it seems to have a small dial inside."
	origin_tech = "syndicate=3"
	var/list/clothing_choices = list()

	New()
		..()
		var/blocked = list(/obj/item/clothing/gloves/chameleon)//Prevent infinite loops and bad hats.
		for(var/U in typesof(/obj/item/clothing/gloves)-blocked)
			var/obj/item/clothing/gloves/V = new U
			src.clothing_choices[V.name] = U
		return

	emp_act(severity) //Because we don't have psych for all slots right now but still want a downside to EMP.  In this case your cover's blown.
		name = "black gloves"
		desc = "It looks like a pair of gloves, but it seems to have a small dial inside."
		icon_state = "black"
		item_color = "brown"
		update_icon()
		usr.update_inv_gloves()

	verb/change()
		set name = "Change Gloves Appearance"
		set category = "Object"
		set src in usr

		var/picked = input("Select gloves to change it to", "Chameleon Gloves")as null|anything in clothing_choices
		if(!picked || !clothing_choices[picked])
			return
		var/newtype = clothing_choices[picked]
		var/obj/item/clothing/A = new newtype

		desc = null
		permeability_coefficient = 0.90

		desc = A.desc
		name = A.name
		icon_state = A.icon_state
		item_state = A.item_state
		item_color = A.item_color
		flags_inv = A.flags_inv
		if(usr)
			usr.update_inv_gloves()	//so our overlays update.

//******************
//**Chameleon Mask**
//******************

/obj/item/clothing/mask/chameleon
	name = "gas mask"
	icon_state = "gas_alt"
	item_state = "gas_alt"
	desc = "It looks like a plain gask mask, but on closer inspection, it seems to have a small dial inside."
	origin_tech = "syndicate=3"
	var/list/clothing_choices = list()

	New()
		..()
		var/blocked = list(/obj/item/clothing/mask/chameleon)//Prevent infinite loops and bad hats.
		for(var/U in typesof(/obj/item/clothing/mask)-blocked)
			var/obj/item/clothing/mask/V = new U
			if(V)
				src.clothing_choices[V.name] = U
		return

	emp_act(severity) //Because we don't have psych for all slots right now but still want a downside to EMP.  In this case your cover's blown.
		name = "gas mask"
		desc = "It's a gas mask."
		icon_state = "gas_alt"
		update_icon()
		usr.update_inv_wear_mask()
	verb/change()
		set name = "Change Mask Appearance"
		set category = "Object"
		set src in usr

		var/picked = input("Select mask to change it to", "Chameleon Mask")as null|anything in clothing_choices
		if(!picked || !clothing_choices[picked])
			return
		var/newtype = clothing_choices[picked]
		var/obj/item/clothing/A = new newtype

		desc = null
		permeability_coefficient = 0.90

		desc = A.desc
		name = A.name
		icon_state = A.icon_state
		item_state = A.item_state
		flags_inv = A.flags_inv
		if(usr)
			usr.update_inv_wear_mask()	//so our overlays update.

//*********************
//**Chameleon Glasses**
//*********************

/obj/item/clothing/glasses/chameleon
	name = "Optical Meson Scanner"
	icon_state = "meson"
	item_state = "glasses"
	desc = "It looks like a plain set of mesons, but on closer inspection, it seems to have a small dial inside."
	origin_tech = "syndicate=3"
	var/list/clothing_choices = list()

	New()
		..()
		var/blocked = list(/obj/item/clothing/glasses/chameleon)//Prevent infinite loops and bad hats.
		for(var/U in typesof(/obj/item/clothing/glasses)-blocked)
			var/obj/item/clothing/glasses/V = new U
			src.clothing_choices[V.name] = U
		return

	emp_act(severity) //Because we don't have psych for all slots right now but still want a downside to EMP.  In this case your cover's blown.
		name = "Optical Meson Scanner"
		desc = "It's a set of mesons."
		icon_state = "meson"
		update_icon()
		usr.update_inv_glasses()

	verb/change()
		set name = "Change Glasses Appearance"
		set category = "Object"
		set src in usr

		var/picked = input("Select glasses to change it to", "Chameleon Glasses")as null|anything in clothing_choices
		if(!picked || !clothing_choices[picked])
			return
		var/newtype = clothing_choices[picked]
		var/obj/item/clothing/A = new newtype

		desc = null
		permeability_coefficient = 0.90

		desc = A.desc
		name = A.name
		icon_state = A.icon_state
		item_state = A.item_state
		flags_inv = A.flags_inv
		if(usr)
			usr.update_inv_glasses()	//so our overlays update.

//*****************
//**Chameleon Gun**
//*****************
/obj/item/weapon/gun/projectile/chameleon
	name = "desert eagle"
	desc = "A fake Desert Eagle with a dial on the side to change the gun's disguise."
	icon_state = "deagle"
	w_class = 3.0
	max_shells = 7
	caliber = ".45"
	origin_tech = "combat=2;materials=2;syndicate=8"
	ammo_type = "/obj/item/ammo_casing/chameleon"
	var/list/gun_choices = list()

	New()
		..()
		var/blocked = list(/obj/item/weapon/gun/projectile/chameleon)
		for(var/U in typesof(/obj/item/weapon/gun/)-blocked)
			var/obj/item/weapon/gun/V = new U
			src.gun_choices[V.name] = U
		return

	emp_act(severity)
		name = "desert eagle"
		desc = "It's a desert eagle."
		icon_state = "deagle"
		update_icon()
		usr.update_inv_r_hand()
		usr.update_inv_l_hand()

	verb/change()
		set name = "Change Gun Appearance"
		set category = "Object"
		set src in usr

		var/picked = input("Select gun to change it to", "Chameleon Gun")as null|anything in gun_choices
		if(!picked || !gun_choices[picked])
			return
		var/newtype = gun_choices[picked]
		var/obj/item/weapon/gun/A = new newtype

		desc = null
		permeability_coefficient = 0.90

		desc = A.desc
		name = A.name
		icon_state = A.icon_state
		item_state = A.item_state
		flags_inv = A.flags_inv
		if(usr)
			usr.update_inv_r_hand()
			usr.update_inv_l_hand()	//so our overlays update.