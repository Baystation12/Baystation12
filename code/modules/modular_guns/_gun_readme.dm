/*
	MODULAR/COMPOSITE GUN SYSTEM

	Think of it like Borderlands. Guns are composed of five pieces, these being the barrel,
	body, chamber, grip and stock. Gun size/weight/accuracy/combat values are all calculated
	by combining the aspects of each of these components.

	The barrel determines the maximum bore (caliber) and overall accuracy of the gun. In the case
	of laser weapons this also determines the type of projectile fired.

	The body determines a lot of the physical aspects of the gun (weight, inventory slots).

	The chamber determines the available fire modes, load method, ammo, firing style, etc.

	The grip and stock both modify accuracy and recoil and may increase overall weapon size.

	Each component may belong to a model, which changes the aesthetic and combat aspects of the
	component. Building a gun from components from the same model will give a series of overall
	quality bonuses and may offer unique benefits/mods depending on the manufacturer.

	Accessories can also be installed into guns if the components are compatible with them. These
	will include bayonets, stabilizers, scopes, brass catchers, ammo fabricators, so on, so forth.
	Accessories are limited; only one accessory can be installed per component.

	Guns may be field stripped for parts and rebuilt using other components.

	MODELS

	Models provide cosmetic icons and strings to a gun, as well as a possible set of bonuses due
	to their manufacturer if all components are of the same model.

	MANUFACTURERS

	When all parts of a gun share a model, the gun may recieve manufacturer bonuses and cosmetic information
	according to the appropriate manufacturer datum, as specified in the model datum.

	Modifiers are multiplicative; if they are not null, the corresponding values on the finished gun
	will be multiplied by the value of the modifier.

	ADDING PREBUILT GUN ITEMS:

	Prebuilt (ie. mapped or spawned) weapons require one to four pieces of information. The first
	and most important is the list of components making up the weapon. The second is a model, if
	any, for the components to be produced by. The third/fourth are override icon information and
	are optional; these are solely used for making the object appear properly in the mapper.

*/