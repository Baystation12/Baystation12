#define CRAFT_ONE_PER_TURF 1
#define CRAFT_ON_FLOOR     2




#define CRAFT_OBJECT	"object"
//A single object which is moved inside the craft item, and will be deleted when its complete
//Arguments:
//Types (list),
	//A list of valid typepaths. All subpaths will be included
//Worktime:
	//Time in deciseconds required to complete the operation. A value of -1, or not specifying anything, will use the recipe's general worktime
//noconsume
	//If noconsume is set true, the object will not be moved in or deleted



#define CRAFT_MATERIAL		"material"
//A quantity of sheets of materials which are used to craft something.
//Arguments:
//Material name:
	//Should be one of the MATERIAL_XXXX defines, from __defines/materials.dm
//Quantity
	//How many sheets of material to use. This will be subtracted from the material stack which is applied]
//Worktime:
	//Time in deciseconds required to complete the operation. A value of -1, or not specifying anything, will use the recipe's general worktime


#define CRAFT_STACK		"stack"
//A quantity of some non-material stack object
//Arguments:
//Type
	//A typepath of which stack to use, subtypes are counted too
//Quantity
	//How many units of the stack to use, this is subtracted from the quantity
//Worktime:
	//Time in deciseconds required to complete the operation. A value of -1, or not specifying anything, will use the recipe's general worktime


#define CRAFT_TOOL	"tool"
//A tool with specified qualities which must be used on the craft.
//The tool is not used up by this operation, but it will consume its own resources as normal (fuel, power, quantity, etc)
//Arguments:
	//Required quality, must be one of the QUALITY_XXXX defines in tools_and_qualities.dm
	//Required level, must be a number generally in the range 0-50
	//Worktime:Time in deciseconds required to complete the operation. A value of -1, or not specifying anything, will use the recipe's general worktime
	//Failchance: The difficulty of the tool operation
	//Required skill: UNIMPLEMENTED: This is subtracted from the required level, and also set as the failchance on



#define CRAFT_PASSIVE	"passive"
//This is put into the passive steps list, not the normal steps list
//Requires a tool to be near the crafting site. Within 1 tile generally
//The presence of this tool is checked for, and use_tool is called on it, at every crafting step.
//This is primarily intended for workbenches, and similar emplaced-object tools which cannot be picked up
//Arguments:
		//Required quality, must be one of the QUALITY_XXXX defines in tools_and_qualities.dm
		//Required level, must be a number generally in the range 0-50




