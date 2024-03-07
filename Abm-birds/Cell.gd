extends Node2D

@export var resourceCount : int;
@export var temperature : int;
@export var id : Vector2;

# Returns whether an agent can a given amount of resources from
# this cell
func GetResources(amount : int):
	if(resourceCount >= amount):
		resourceCount -= amount;
		return true;
	
	# Does not have enough resources 
	return false;
