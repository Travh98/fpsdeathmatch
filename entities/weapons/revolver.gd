class_name Revolver
extends Node3D

@onready var ammo: Ammo = $Ammo
@onready var ranged_damage: RangedDamage = $RangedDamage
@onready var muzzle_flash: MuzzleFlash = $MuzzleFlash
@onready var bullet_tracer: BulletTracer = $BulletTracer
@onready var western_gunshot_sfx: RandomSfx = $WesternGunshotSfx
@onready var shoot_cooldown: ShootCooldown = $ShootCooldown
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var rotate_revolver_cylinder: RotateRevolverCylinder = $RotateRevolverCylinder
@onready var reloading_cooldown: ReloadingCooldown = $ReloadingCooldown


## The mob that is using this weapon
var mob: Node
var gun_cocked: bool = true


func reload():
	reloading_fx()
	reloading_cooldown.reload()
	ammo.reload_magazine()
	ServerPlayerAnimsRpcs.on_player_reload.rpc_id(1, int(mob.name))


func reset():
	ammo.reload_magazine()
	if anim_player.is_playing():
		anim_player.stop()


func use_primary(eye_cast: RayCast3D, hitbox_cast: RayCast3D):
	if anim_player.is_playing():
		return
	
	if not ammo.is_ammo_loaded():
		#print("out of ammo")
		reload()
		return
	
	if not reloading_cooldown.is_reloaded():
		return
	
	if shoot_cooldown.is_cooling_down():
		return
	shoot_cooldown.shot_taken()
	
	ammo.use_ammo()
	
	if eye_cast.is_colliding():
		bullet_tracer.fire_visuals(eye_cast.get_collision_point())
	else:
		bullet_tracer.fire_visuals(global_position + Vector3.FORWARD * 1000)
	
	var hit_target = hitbox_cast.get_collider()
	if hit_target is HitBox:
		# Make sure you didn't shoot yourself
		if hit_target.mob == mob:
			return
		
		hit_target.take_hit(ranged_damage.damage)
		#print("dealing dmg to ", hit_target)
	
	shooting_fx()
	## Tell server this player just shot
	ServerPlayerAnimsRpcs.on_player_shot.rpc_id(1, int(mob.name))


## Visual and audio effects for when shooting
func shooting_fx():
	muzzle_flash.flash()
	western_gunshot_sfx.play_sound()
	anim_player.stop()
	anim_player.play("shoot_and_recock")
	rotate_revolver_cylinder.rotate_cylinder()
	bullet_tracer.fire_visuals(global_position - global_transform.basis.z * 1000)


func reloading_fx():
	anim_player.play("reload_anim")
