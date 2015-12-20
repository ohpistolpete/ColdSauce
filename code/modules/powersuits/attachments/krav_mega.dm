/obj/item/weapon/powersuit_attachment/krav_maga
	name = "krav maga module"
	attachment_type = POWERSUIT_PRIMARY

	power_punch(var/mob/living/victim, var/mob/living/assaulter, var/obj/item/organ/limb/affecting, var/armor_block, var/a_intent)

		if(a_intent != "disarm")
			return
		var/obj/item/stolen = victim.get_active_hand()

		if(!stolen)
			return

		attached_to.cell.charge -= 500

		victim.visible_message("<span class='danger'>[assaulter] takes [stolen] from [victim]!</span>", \
						"<span class='userdanger'>[assaulter] takes [stolen] from [victim]!</span>")
		playsound(loc, 'sound/effects/woodhit.ogg', 50, 1, -1)

		victim.remove_from_mob(stolen)
		assaulter.put_in_active_hand(stolen)

		//logging
		if (victim.stat == DEAD)
			add_logs(assaulter, victim, "disarmed", addition=" (DAMAGE: [fist_damage]) (REMHP: DEAD)")
		else
			add_logs(assaulter, victim, "disarmed", addition=" (DAMAGE: [fist_damage]) (REMHP: [victim.health - fist_damage])")


		return 1