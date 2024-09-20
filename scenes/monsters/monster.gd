extends RigidBody2D

@onready var monster
@onready var character = $AnimatedSprite2D
@onready var movement_configs = {
	"timer": 0.0,
	"change_time": 2.0,
	
	"speed": 100,
	"direction": Vector2.ZERO,
	
	"is_moving": true,
	"is_stopped": false
}

func _ready():
	$Label.text = monster.id
	change_direction()
	set_random_change_time()
	character.play("walk")

func _on_monster_clicked(viewport, event, shape_idx):
	if Global.is_left_click(event):
		stop_movement()
		if !Global.is_my_farm:
			Alert.steal_or_kill(self)
		else:
			Alert.monster_info(self)

func _process(delta):
	if movement_configs.is_stopped:
		return
	
	movement_configs.timer += delta
	if movement_configs.timer >= movement_configs.change_time:
		movement_configs.timer = 0.0
		toggle_movement()
	
	if movement_configs.is_moving:
		handle_movement(delta)
		update_animation_direction()

func handle_movement(delta):
	var movement = movement_configs.direction * movement_configs.speed * delta
	var collision = move_and_collide(movement)
	if collision:
		movement_configs.direction = movement_configs.direction.bounce(collision.get_normal())

func update_animation_direction():
	character.flip_h = movement_configs.direction.x < 0

func toggle_movement():
	movement_configs.is_moving = !movement_configs.is_moving
	if movement_configs.is_moving:
		change_direction()
		set_random_change_time()
		character.play("walk")
	else:
		character.stop()
		character.play("idle")

func change_direction():
	movement_configs.direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

func set_random_change_time():
	movement_configs.change_time = randf_range(1.0, 3.0)

func stop_movement():
	movement_configs.is_stopped = true
	movement_configs.is_moving = false
	character.stop()
	character.play("idle")
