extends CharacterBody2D

@onready var animation: AnimationPlayer = get_node("Animation")
@onready var texture: Sprite2D = get_node("Texture")
@onready var attack_area_collision: CollisionShape2D = get_node("AttackArea/Collision")
@export var move_speed: float = 256.0
var can_attack: bool = true
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	if can_attack == false:
		return
	move()
	animate()
	attack_handler()

func move() -> void:
	var direction: Vector2 = get_direction()
	velocity = direction * move_speed
	move_and_slide()

func get_direction() -> Vector2:
	return Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()

func animate() -> void:
	if velocity.x > 0:
		texture.flip_h = false
		attack_area_collision.position.x = 55
	if velocity.x < 0:
		texture.flip_h = true
		attack_area_collision.position.x = -55
		
	if can_attack == false:
		return
	if velocity != Vector2.ZERO:
		animation.play("run")
		return
	if velocity == Vector2.ZERO:
		animation.play("idle")
		return
	animation.pause()
	return

func attack_handler() -> void:
	print(can_attack)
	if Input.is_action_just_pressed("attack") and can_attack:
		can_attack = false
		attack_area_collision.disabled = false
		animation.play("atack")


func _on_animation_animation_finished(_anim_name: String):
	can_attack = true
	attack_area_collision.disabled = true
