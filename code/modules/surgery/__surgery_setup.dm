#define SURGERY_NO_ROBOTIC        1
#define SURGERY_NO_CRYSTAL        2
#define SURGERY_NO_STUMP          4
#define SURGERY_NO_FLESH          8 
#define SURGERY_NEEDS_INCISION   16
#define SURGERY_NEEDS_RETRACTED  32
#define SURGERY_NEEDS_ENCASEMENT 64

#define  SURGERY_SKILLS_GENERIC				list(SKILL_ANATOMY = SKILL_TRAINED, SKILL_MEDICAL = SKILL_EXPERIENCED)
#define  SURGERY_SKILLS_DELICATE			list(SKILL_ANATOMY = SKILL_EXPERIENCED, SKILL_MEDICAL = SKILL_EXPERIENCED)
#define  SURGERY_SKILLS_ROBOTIC				list(SKILL_DEVICES = SKILL_TRAINED)
#define  SURGERY_SKILLS_ROBOTIC_ON_MEAT		list(SKILL_ANATOMY = SKILL_TRAINED, SKILL_DEVICES = SKILL_TRAINED) 
