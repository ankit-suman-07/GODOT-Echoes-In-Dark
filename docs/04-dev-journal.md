# Development Journal

This document tracks the development process, lessons learned, and technical decisions made throughout the project.

---

# Template

---

## Date

### Goal

What was planned?

---

### Completed

* Task
* Task
* Task

---

### Learned

* New Godot feature
* Programming concept
* Design concept

---

### Challenges

Describe any issues encountered.

---

### Solution

How the issue was resolved.

---

### Next Steps

What will be implemented next?

---

# Example Entry

## June 25, 2026

### Goal

Implement player movement.

---

### Completed

* CharacterBody2D movement
* Sprinting
* Camera follow

---

### Learned

* Godot Input Map
* `_physics_process()`
* CharacterBody2D movement

---

### Challenges

Movement felt slippery.

---

### Solution

Tweaked acceleration and deceleration values until movement felt responsive.

---

### Next Steps

* Flashlight system
* Interaction system

---

# Lessons Learned

Use this section to record important concepts discovered during development.

Example:

## Finite State Machine

### What I Learned

Enemy behavior can be broken into individual states instead of using one large script.

### Why It Matters

Makes AI easier to extend and debug.

### Implementation

Patrol → Chase → Patrol

---

## Line of Sight

### What I Learned

Raycasts can determine whether the enemy has a clear path to the player.

### Future Improvements

Reduce raycast frequency for better performance.
