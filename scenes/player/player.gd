extends CharacterBody2D

const MOVEMENT_RUNNING_SPEED: float = 100.0
const MOVEMENT_SLOWING_SPEED: float = 100.0

enum PLAYER_STATES {
    BUSY = 10, # used for cutscenes / manual control
    DIED = 20,
    IDLE = 30,
    MOVE = 40,
    JUMP = 50,
}

var state: int = PLAYER_STATES.IDLE


func _physics_process(delta: float) -> void:
    if (state <= PLAYER_STATES.BUSY): return
    if (state <= PLAYER_STATES.DIED):
        move_and_slide()
        return
    state = PLAYER_STATES.IDLE
    _movement_horizontal(delta)
    _movement_vertical(delta)
    move_and_slide()


func _movement_horizontal(delta: float) -> void:
    var input_dir: float = Input.get_axis('', '')
    if (input_dir == 0):
        velocity.x -= sign(velocity.x) * delta * MOVEMENT_SLOWING_SPEED
        if (abs(velocity.x) > 0): state = PLAYER_STATES.MOVE
        return
    if (input_dir != sign(velocity.x)): velocity.x = 0
    velocity.x += input_dir * delta * MOVEMENT_RUNNING_SPEED
    state = PLAYER_STATES.MOVE


func _movement_vertical(delta: float) -> void:
    pass