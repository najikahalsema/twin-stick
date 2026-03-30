class_name IceWeaponItem extends Item

## Change the Weapon's script to match the weapon Pickup
func use(player: Player) -> void:
	player.change_weapon(preload("uid://njlnqf7vxeg6"), preload("uid://djnqskxeihg82"))
