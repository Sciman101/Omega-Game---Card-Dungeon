extends GridContainer

const NUM_DISPLAYED_INVENTORY_SLOTS = 8
const INVENTORY_ROW_SIZE = 4

@onready var inventory_slots = get_children()

var row_offset : int = 0
var num_rows : int = 0
var selected_slot = null

var last_selected_slot_index := 0

var viewing_inventory : bool = false

signal on_item_selected(item, slot_number)
signal on_item_hovered(item, slot_number)

func _ready():
	update_inventoty_slots()
	on_item_selected.connect(_on_done_browsing)

# Navigate
func _input(event):
	if not viewing_inventory:
		if not Game.is_player_locked():
			if Input.is_action_just_pressed("inventory"):
				viewing_inventory = true
				select_slot(last_selected_slot_index)
				Game.lock_player()
	else:
		if Input.is_action_just_pressed("left"):
			move_selection(-1,0)
		elif Input.is_action_just_pressed("right"):
			move_selection(1,0)
		elif Input.is_action_just_pressed("up"):
			move_selection(0,-1)
		elif Input.is_action_just_pressed("down"):
			move_selection(0,1)
		elif Input.is_action_just_pressed("interact"):
			on_item_selected.emit(selected_slot.item, selected_slot.index)
		elif Input.is_action_just_pressed("inventory"):
			on_item_selected.emit(null, -1)
			

func _on_done_browsing(slot, index):
	Game.unlock_player()
	viewing_inventory = false
	deselect_all_slots()

# Updates the visual for each inventory slot to populate it with the corresponding item
# If offset is nonzero, it will start from the nth item. Used for pagination
func update_inventoty_slots() -> void:
	var inventory = Game.inventory
	num_rows = ceil(float(inventory.size()) / INVENTORY_ROW_SIZE)
	
	var slot_offset = row_offset * INVENTORY_ROW_SIZE
	for i in range(NUM_DISPLAYED_INVENTORY_SLOTS):
		var slot = inventory_slots[i]
		var inventory_index = slot_offset + i
		if inventory_index < inventory.size():
			slot.set_item(inventory[inventory_index])
		else:
			slot.set_item(null)
		slot.index = inventory_index
		slot.set_highlighted(false)

func deselect_all_slots() -> void:
	if selected_slot:
		selected_slot.set_highlighted(false)
		last_selected_slot_index = selected_slot.index
		selected_slot = null

func select_slot(index:int) -> void:
	var inventory = Game.inventory
	if inventory.size() <= NUM_DISPLAYED_INVENTORY_SLOTS: # No need to offset if the inventory is too small
		row_offset = 0
	index = clamp(index, 0, inventory.size() - 1)
	
	deselect_all_slots()
	
	var target_row = floor(index / INVENTORY_ROW_SIZE)
	if target_row < row_offset or target_row > row_offset + 1:
		row_offset = min(target_row, row_offset + 1)
		update_inventoty_slots()
	
	var slot_index = index - row_offset * INVENTORY_ROW_SIZE
	selected_slot = inventory_slots[slot_index]
	selected_slot.set_highlighted(true)
	
	on_item_hovered.emit(selected_slot.item, selected_slot.index)

func move_selection(x:int,y:int):
	if selected_slot:
		var index = selected_slot.index
		var col = index % INVENTORY_ROW_SIZE
		var row = index / INVENTORY_ROW_SIZE
		
		if (x > 0 and col != INVENTORY_ROW_SIZE - 1) or \
			(x < 0 and col != 0):
				index += x
		
		if (y > 0 and row != num_rows - 1) or \
			(y < 0 and row != 0):
				index += y * INVENTORY_ROW_SIZE
		
		index = clamp(index, 0, Game.inventory.size() - 1)
		select_slot(index)
