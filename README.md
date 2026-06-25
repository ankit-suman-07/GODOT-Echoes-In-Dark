# Echoes in the Dark

## Project Overview

**Echoes in the Dark** is a simple 2D horror game developed in Unity/Godot. The player explores a dark, abandoned facility while avoiding a hostile creature that patrols the environment and actively hunts the player when detected.

The objective is to collect key items, uncover fragments of the story, and escape before being caught.

The project is intentionally scoped as a small, portfolio-quality game that focuses on core horror mechanics rather than large amounts of content. The goal is to demonstrate gameplay programming, AI behavior, atmosphere design, and game systems commonly used in horror games.

---

# Objectives

## Primary Goal

Collect the required key items, unlock the exit, and escape the facility.

## Failure Condition

The player is caught by the creature.

## Secondary Goal

Discover story notes scattered throughout the environment to learn what happened inside the facility.

---

# Core Features

## 1. Player Controller

### Features

- 2D character movement
- Sprinting
- Collision handling
- Interaction system

### Learning Goals

- Input handling
- Physics and collisions
- Character controller architecture

---

## 2. Flashlight & Darkness System

### Features

- Limited visibility
- Flashlight toggle
- Battery drain system
- Battery pickups

### Learning Goals

- 2D lighting
- Resource management
- Atmosphere creation

---

## 3. Enemy AI

### AI States

- Idle
- Patrol
- Chase

### Behavior

- Patrols predefined waypoints
- Detects player using line-of-sight
- Chases player when spotted
- Returns to patrol after losing sight

### Learning Goals

- Finite State Machines (FSM)
- AI perception systems
- State transitions

---

## 4. Line of Sight System

### Features

- Vision radius
- Obstacle detection
- Visibility checks using raycasts

### Learning Goals

- Raycasting
- AI perception
- Stealth mechanics

---

## 5. Audio System

### Features

- Ambient sounds
- Footstep sounds
- Enemy sounds
- Chase music

### Learning Goals

- Audio management
- Dynamic tension building
- Player feedback

---

## 6. Item Collection System

### Features

- Keys
- Batteries
- Story notes

### Learning Goals

- Inventory basics
- Interactable objects
- Event-driven gameplay

---

## 7. Key & Door Progression

### Features

- Locked doors
- Key requirements
- Exit door

### Learning Goals

- Progression systems
- Level gating
- Objective management

---

## 8. Story Notes

### Features

- Collectible notes
- Environmental storytelling
- Optional lore

### Learning Goals

- Narrative design
- UI interaction
- Content systems

---

## 9. Safe Room

### Features

- Enemy cannot enter
- Checkpoint/save point
- Temporary relief from tension

### Learning Goals

- Horror pacing
- Trigger zones
- Checkpoint systems

---

## 10. Win/Lose Conditions

### Win

- Collect required key
- Reach exit

### Lose

- Enemy catches player

### Learning Goals

- Game state management
- Scene transitions

---

# Technical Scope

## Engine

- Unity 6

## Language

- C#

## Target Platform

- Windows PC

## Perspective

- 2D Top-Down

---

# Systems Architecture

## Core Managers

### GameManager

Responsibilities:

- Game states
- Win/Lose handling
- Scene management

### AudioManager

Responsibilities:

- Sound playback
- Music transitions
- Volume control

### UIManager

Responsibilities:

- Menus
- Inventory UI
- Notes UI

---

# AI Architecture

## Enemy FSM

```text
Idle
  ↓
Patrol
  ↓
Detect Player
  ↓
Chase
  ↓
Lose Player
  ↓
Return To Patrol
```

---

# Level Design

## Map Structure

```text
Start Area
    ↓
Exploration Zone A
    ↓
Exploration Zone B
    ↓
Safe Room
    ↓
Locked Exit
```

### Collectibles

- 3 Batteries
- 3 Story Notes
- 1 Exit Key

---

# Art Scope

## Environment

- Dark corridors
- Storage rooms
- Utility rooms

## Characters

- Simple player sprite
- Single enemy sprite

## Visual Effects

- Flashlight cone
- Flickering lights
- Basic particles

---

# Audio Scope

## Ambient

- Wind
- Electrical hum
- Distant noises

## Sound Effects

- Footsteps
- Door interactions
- Key pickups

## Music

- Exploration theme
- Chase theme

---

# Development Milestones

## Milestone 1

Player movement and camera.

## Milestone 2

Flashlight and lighting system.

## Milestone 3

Enemy FSM and patrol behavior.

## Milestone 4

Line-of-sight detection.

## Milestone 5

Chase system.

## Milestone 6

Items, keys, and doors.

## Milestone 7

Notes and storytelling.

## Milestone 8

Audio implementation.

## Milestone 9

Safe room and checkpoints.

## Milestone 10

Polish and bug fixing.

---

# Skills Demonstrated

- Unity 2D Development
- C# Programming
- Finite State Machines (FSM)
- AI Pathfinding
- Line of Sight Detection
- Event-Driven Programming
- Resource Management Systems
- Audio Design
- Level Design
- Horror Game Design Principles

---

# Future Enhancements (Out of Scope)

- Multiple enemy types
- Procedural generation
- Multiplayer
- Advanced inventory system
- Save/load slots
- Sanity mechanics
- Dynamic weather
- Voice acting

These features are intentionally excluded to maintain a realistic and achievable project scope.

---

# Estimated Project Size

**Target Development Time:** 2–6 weeks (part-time)

**Target Playtime:** 10–20 minutes

**Target Map Count:** 1 small interconnected facility

**Target Enemy Types:** 1

**Target Collectibles:**

- 3 Story Notes
- 3 Batteries
- 1 Exit Key