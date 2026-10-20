extends CharacterBody2D

@onready var duck: AnimatedSprite2D = $Bird
@onready var collision0: CollisionPolygon2D = $CollisionFrame0
@onready var collision1: CollisionPolygon2D = $CollisionFrame1

const GRAVITY: int = 1400
const MAX_VEL: int = 500
const FLAP_SPEED: int = -350
const START_POS = Vector2(36, 180)

var flying: bool = false
var falling: bool = false

func _ready() -> void:
	duck.frame_changed.connect(update_collision)
	update_collision()
	reset()

func update_collision() -> void:
	collision0.set_deferred("disabled", duck.frame != 0)
	collision1.set_deferred("disabled", duck.frame != 1)

func reset() -> void:
	flying = false
	falling = false
	position = START_POS
	set_rotation(0)
	$Bird.stop()
	
func _physics_process(delta) -> void:
	if flying or falling:
		velocity.y += GRAVITY * delta
		if velocity.y > MAX_VEL:
			velocity.y = MAX_VEL
		if flying:
			$Bird.play("flying")
		elif falling:
			$Bird.stop()
			set_rotation(PI / 2)
		move_and_collide(velocity * delta)
		
func flap() -> void:
	velocity.y = FLAP_SPEED
	
