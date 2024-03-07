extends Node2D

@export var coldTolerance : int;
@export var heatTolerance : int;

@export var idealLocationWintering : Vector2;
@export var idealLocationBreeding  : Vector2;

@export var moveSpeed : int;
@export var birdState : AgentState;

const temperatureMin : int = 10;
const temperatureMax : int = 90;

# Represents the bird’s current state that shows 
# us whether the bird is staying in one place or 
# currently traveling. 
enum AgentState { WINTERING_TO_BREEDING, BREEDING_TO_WINTERING, WINTERING, BREEDING };

func StateMachine():
	match(birdState):
		AgentState.WINTERING_TO_BREEDING:
			print("Flying to breeding location");
		AgentState.BREEDING:
			print("Flying to breeding location");
		AgentState.BREEDING_TO_WINTERING:
			print("Flying to wintering location");
		AgentState.WINTERING:
			print("Staying at wintering location");
		

func Migrate():
	pass;
	
func Feat():
	pass;

func Breed():
	pass;

func Explore():
	pass;

