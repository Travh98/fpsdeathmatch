class_name GodootManPlayerModel
extends Node3D

## Drives the animations for the Godoot PlayerModel

## AnimTree for blending between leg and arm animations
@onready var anim_tree: AnimationTree = $AnimationTree
## Head Look at follows the bone: spine.005, looks at the IK Target
@onready var head_look_at: LookAtModifier3D = $GodootManRig/Skeleton3D/HeadLookAt
## SkeletonIK3D node for bending the spine with the head movement.
## Root bone is spine.003, tip bone is spine.005.
## Target is the HeadLookAtIkTarget Node of the player scene.
@onready var bend_spine_ik: SkeletonIK3D = $GodootManRig/Skeleton3D/BendSpineIk
## Inverse kinematics for the right arm
@onready var right_arm_ik: SkeletonIK3D = $GodootManRig/Skeleton3D/RightArmIk

@export var lerp_speed: float = 8.0

## The desired value for the running anim parameter
var target_running_percent: float = 0.0
## The current value of the running parameter
var running_percent: float = 0.0


func start_ik():
	bend_spine_ik.start()


func on_hand_item_held():
	right_arm_ik.start()


func set_running_pct(running_pct: float):
	target_running_percent = running_pct


func _physics_process(delta):
	# Smoothly lerp to the desired running parameter value
	running_percent = lerp(running_percent, target_running_percent, delta * lerp_speed)
	# Update the animation tree
	anim_tree.set("parameters/Running/blend_amount", running_percent)
