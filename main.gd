extends Node

@export var mob_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func game_over():
	get_node("ScoreTimer").stop()
	get_node("MobTimer").stop()
	get_node("HUD").show_game_over()
	get_node("Music").stop()
	get_node("DeathSound").play()
	
	
func new_game():
	score = 0
	get_node("Player").start(get_node("StartPosition").position)
	get_node("StartTimer").start()
	get_node("HUD").update_score(score)
	get_node("HUD").show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	get_node("Music").play()


func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()
	
	var direction = mob_spawn_location.rotation + PI / 2
	
	mob.position = mob_spawn_location.position
	
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)


func _on_score_timer_timeout():
	score += 1
	get_node("HUD").update_score(score)


func _on_start_timer_timeout():
	get_node("MobTimer").start()
	get_node("ScoreTimer").start()
