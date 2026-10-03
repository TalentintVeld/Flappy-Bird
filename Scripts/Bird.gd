extends CharacterBody2D

const GRAVITY: int = 1500
const MAX_VEL: int = 500
const FLAP_SPEED: int = -350
const START_POS = Vector2(36, 180)
var flying: bool = false
var falling: bool = false

func _ready() -> void:
	reset()
	
func reset() -> void:
	flying = false
	falling = false
	position = START_POS
	set_rotation(0)
	
func _physics_process(delta) -> void:
	if flying or falling:
		velocity.y += GRAVITY * delta
		if velocity.y > MAX_VEL:
			velocity.y = MAX_VEL
		if flying:
			set_rotation(deg_to_rad(velocity.y * 0.05))
			$AnimatedSprite2D.play()
		elif falling:
			set_rotation(PI / 2)
			$AnimatedSprite2D.stop()
		move_and_collide(velocity * delta)
	else:
		$AnimatedSprite2D.stop()
		
func flap() -> void:
	velocity.y = FLAP_SPEED
	
