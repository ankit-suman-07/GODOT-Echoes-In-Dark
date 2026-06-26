# Game Design

## Game Summary

Echoes in the Dark is a short exploration-based horror game focused on tension rather than combat.

---

# Core Gameplay Loop

```text
Explore
    ↓
Search Rooms
    ↓
Collect Items
    ↓
Avoid Creature
    ↓
Unlock Exit
    ↓
Escape
```

---

# Player

## Abilities

* Walk
* Sprint
* Interact
* Use flashlight

---

# Enemy

## States

```text
Patrol
   ↓
Detect Player
   ↓
Chase
   ↓
Lose Player
   ↓
Patrol
```

---

# Flashlight

Purpose:

* Reveal dark areas
* Guide exploration
* Increase tension

Mechanics:

* Toggle On/Off
* Battery drains over time
* Batteries restore charge

---

# Resources

| Item       | Purpose                    |
| ---------- | -------------------------- |
| Battery    | Recharge flashlight        |
| Key        | Unlock exit                |
| Story Note | Environmental storytelling |

---

# Progression

1. Explore
2. Find batteries
3. Collect story notes
4. Obtain exit key
5. Unlock exit
6. Escape

---

# Horror Design Principles

* Limited visibility
* Resource scarcity
* Enemy unpredictability
* Environmental storytelling
* Safe room for tension relief

---

# Win Condition

Escape through the exit.

---

# Lose Condition

Enemy catches the player.
