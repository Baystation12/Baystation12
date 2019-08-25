/obj/random/lathe_disk
	name = "random lathe disk"
	icon_state = "tech-green"

/obj/random/lathe_disk/item_to_spawn()
	return pickweight(list(
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/misc = 10,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/devices = 8,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/tools = 3,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/components = 5,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/adv_tools = 2,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/circuits = 3,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/medical = 4,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/computer = 4,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/security = 3,
				//Firearms related disks disabled until we implement deadspace guns for security
				///obj/item/weapon/computer_hardware/hard_drive/portable/design/fs_cheap_guns = 2,
				///obj/item/weapon/computer_hardware/hard_drive/portable/design/fs_kinetic_guns = 1,
				///obj/item/weapon/computer_hardware/hard_drive/portable/design/fs_energy_guns = 1,
				///obj/item/weapon/computer_hardware/hard_drive/portable/design/nt_old_guns = 1,
				///obj/item/weapon/computer_hardware/hard_drive/portable/design/nt_new_guns = 0.5,
				///obj/item/weapon/computer_hardware/hard_drive/portable/design/nonlethal_ammo = 5,
				///obj/item/weapon/computer_hardware/hard_drive/portable/design/lethal_ammo = 2
				))

/obj/random/lathe_disk/low_chance
	name = "low chance random lathe disk"
	icon_state = "tech-green-low"
	spawn_nothing_percentage = 80




/obj/random/lathe_disk/advanced
	name = "random advanced lathe disk"
	icon_state = "tech-green"

/obj/random/lathe_disk/advanced/item_to_spawn()
	return pickweight(list(
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/adv_tools = 2,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/security = 1,
				//Firearms related disks disabled until we implement deadspace guns for security
				///obj/item/weapon/computer_hardware/hard_drive/portable/design/fs_kinetic_guns = 1,
				///obj/item/weapon/computer_hardware/hard_drive/portable/design/fs_energy_guns = 1,
				///obj/item/weapon/computer_hardware/hard_drive/portable/design/nt_old_guns = 1,
				///obj/item/weapon/computer_hardware/hard_drive/portable/design/nt_new_guns = 0.5,
				///obj/item/weapon/computer_hardware/hard_drive/portable/design/lethal_ammo = 2
				))

/obj/random/lathe_disk/advanced/low_chance
	name = "low chance advanced lathe disk"
	icon_state = "tech-green-low"
	spawn_nothing_percentage = 80
