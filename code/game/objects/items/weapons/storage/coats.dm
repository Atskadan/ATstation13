/obj/item/clothing/suit/storage/
	var/obj/screen/storage/boxes
	var/obj/screen/close/closer
	var/obj/slot1
	var/obj/slot2

/obj/item/clothing/suit/storage/New()
	src.boxes = new /obj/screen/storage(  )
	src.boxes.name = "storage"
	src.boxes.master = src
	src.boxes.icon_state = "block"
	src.boxes.screen_loc = "7,7 to 9,7"
	src.boxes.layer = 19
	src.closer = new /obj/screen/close(  )
	src.closer.master = src
	src.closer.icon_state = "x"
	src.closer.layer = 20
	src.closer.screen_loc = "9,7"

/obj/item/clothing/suit/storage/proc/view_inv(mob/user as mob)
	if(!user)
		return
	user.client.screen += src.boxes
	user.client.screen += src.closer
	user.client.screen += src.contents
	var/xs = 7
	var/ys = 7
	for(var/obj/O in src.contents)
		O.screen_loc = "[xs],[ys]"
		O.layer = 20
		xs++

/obj/item/clothing/suit/storage/proc/close(mob/user as mob)
	if(!user)
		return
	user.s_active = src
	user.client.screen -= src.boxes
	user.client.screen -= src.closer
	user.client.screen -= src.contents

/obj/item/clothing/suit/storage/MouseDrop(atom/A)
	if(istype(A,/mob/living/carbon))
		src.view_inv(A)

/obj/item/clothing/suit/storage/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(W.w_class > 2 || src.loc == W )
		return
	if(src.contents.len >= 2)
		user << "You have nowhere to place that"
		return
	user.u_equip(W)
	W.loc = src
	if ((user.client && user.s_active != src))
		user.client.screen -= W
	else if(user.s_active == src)
		close(user)
		view_inv(user)
	W.dropped(user)