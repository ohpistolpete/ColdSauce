/*
//////////////////////////////////////

Healing

	Little bit hidden.
	Lowers resistance tremendously.
	Decreases stage speed tremendously.
	Decreases transmittablity temrendously.
	Fatal Level.

Bonus
	Heals toxins in the affected mob's blood stream.

//////////////////////////////////////
*/

/datum/symptom/heal

	name = "Toxic Filter"
	stealth = 1
	resistance = -4
	stage_speed = -4
	transmittable = -4
	level = 6

/datum/symptom/heal/Activate(var/datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB * 10))
		var/mob/living/M = A.affected_mob
		switch(A.stage)
			if(4, 5)
				Heal(M, A)
	return

/datum/symptom/heal/proc/Heal(var/mob/living/M, var/datum/disease/advance/A)

	var/get_damage = rand(8, 14)
	M.adjustToxLoss(-get_damage)
	return 1

/*
//////////////////////////////////////

Metabolism

	Little bit hidden.
	Lowers resistance.
	Decreases stage speed.
	Decreases transmittablity temrendously.
	High Level.

Bonus
	Cures all diseases (except itself) and creates anti-bodies for them until the symptom dies.

//////////////////////////////////////
*/

/datum/symptom/heal/metabolism

	name = "Anti-Bodies Metabolism "
	stealth = -1
	resistance = -1
	stage_speed = -1
	transmittable = -4
	level = 3
	var/list/cured_diseases = list()

/datum/symptom/heal/metabolism/Heal(var/mob/living/M, var/datum/disease/advance/A)
	var/cured = 0
	for(var/datum/disease/D in M.viruses)
		if(D != A)
			cured = 1
			cured_diseases += D.GetDiseaseID()
			D.cure()
	if(cured)
		M << "<span class='notice'>You feel much better.</span>"

/datum/symptom/heal/metabolism/End(var/datum/disease/advance/A)
	// Remove all the diseases we cured.
	var/mob/living/M = A.affected_mob
	if(istype(M))
		if(cured_diseases.len)
			for(var/res in M.resistances)
				if(res in cured_diseases)
					M.resistances -= res
		M << "<span class='notice'>You feel weaker.</span>"

/*
//////////////////////////////////////

Longevity

	Medium hidden boost.
	Large resistance boost.
	Large stage speed boost.
	Large transmittablity boost.
	High Level.

Bonus
	After a certain amount of time the symptom will cure itself.

//////////////////////////////////////
*/

/datum/symptom/heal/longevity

	name = "Longevity"
	stealth = 3
	resistance = 4
	stage_speed = 4
	transmittable = 4
	level = 3
	var/longevity = 30

/datum/symptom/heal/longevity/Heal(var/mob/living/M, var/datum/disease/advance/A)
	longevity -= 1
	if(!longevity)
		A.cure()

/datum/symptom/heal/longevity/Start(var/datum/disease/advance/A)
	longevity = rand(initial(longevity) - 5, initial(longevity) + 5)

/*
//////////////////////////////////////

Hemoglobic Acceleration

	Low hidden boost.
	Medium resistance penalty.
	Low stage speed penalty.
	Low transmittablity penalty.
	Medium Level.

Bonus
	Heals bloodloss.

//////////////////////////////////////
*/

/datum/symptom/heal/bloodregen

	name = "Hemoglobic Acceleration"
	stealth = 1
	resistance = -2
	stage_speed = -1
	transmittable = -1
	level = 3

/datum/symptom/heal/bloodregen/Heal(var/mob/living/carbon/human/M, var/datum/disease/advance/A)
	switch(A.stage)
		if(4,5)
			if (M.blood.get_reagent_amount("blood") < 135)
				M.blood.add_reagent("blood", 5)
		else
			if (M.blood.get_reagent_amount("blood") < 135)
				M.blood.add_reagent("blood", 2.5)

	return

/*
//////////////////////////////////////

Ocular Restoration

	Noticable.
	Lowers resistance.
	Decreases stage speed..
	Decreases transmittablity.
	Moderate Level.

Bonus
	The body generates Imidazonline.

//////////////////////////////////////
*/

/datum/symptom/heal/eyeregen

	name = "Ocular Restoration"
	stealth = -1
	resistance = -2
	stage_speed = -1
	transmittable = -2
	level = 3

/datum/symptom/heal/eyeregen/Heal(var/mob/living/M, var/datum/disease/advance/A)
	..()
	switch(A.stage)
		if(4,5)
			if (M.reagents.get_reagent_amount("imidazoline") < 5)
				M.reagents.add_reagent("imidazoline", 1)
	return

/*
//////////////////////////////////////

Tympanic Repair

	Noticable.
	Lowers resistance.
	Decreases stage speed..
	Decreases transmittablity.
	Moderate Level.

Bonus
	Heals ear damage..

//////////////////////////////////////
*/

/datum/symptom/heal/ear_regen

	name = "Tympanic Repair"
	stealth = -1
	resistance = -1
	stage_speed = -1
	transmittable = -2
	level = 2

/datum/symptom/heal/ear_regen/Heal(var/mob/living/M, var/datum/disease/advance/A)
	..()
	switch(A.stage)
		if(4,5)
			if (M.ear_damage > 4)
				M.ear_damage -= 4
			if(M.ear_deaf > 2)
				M.ear_deaf -= 2
	return