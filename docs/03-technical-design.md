# Technical Design

## Architecture

The project follows a modular architecture where gameplay systems remain loosely coupled.

---

# Project Structure

```text
scenes/
scripts/
audio/
sprites/
ui/
resources/
```

---

# Scene Structure

```text
Main
 ├── Player
 ├── Enemy
 ├── Level
 ├── UI
 └── GameManager
```

---

# Core Systems

## Player

Responsibilities

* Movement
* Input
* Interaction

---

## Enemy

Responsibilities

* Patrol
* Detection
* Chase

---

## Game Manager

Responsibilities

* Game state
* Win/Lose
* Scene transitions

---

## Audio Manager

Responsibilities

* Music
* Ambient sounds
* Sound effects

---

# Enemy FSM

```text
Patrol
   ↓
Detect
   ↓
Chase
   ↓
Lost Player
   ↓
Return Patrol
```

---

# Signals

Example:

```text
PlayerCollectedKey

EnemyDetectedPlayer

PlayerDied

GameWon
```

---

# Folder Organization

```text
Scenes/
Scripts/
Sprites/
Audio/
Fonts/
Resources/
```

---

# Future Improvements

* Multiple enemies
* Better AI
* Save system
* Inventory
* Procedural levels
