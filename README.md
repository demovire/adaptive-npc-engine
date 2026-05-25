# Adaptive NPC Engine
AI driven NPC system for Roblox that uses an LLM to generate dialogue, track simple emotions, and keep short-term memory across conversations.
The goal was to make NPCs feel less static and more reactive over time.

---

## What it does

- NPCs respond using an external AI model (OpenRouter)
- Conversations are stored and trimmed to avoid overload
- AI output includes emotions (like happiness, anger, trust)
- Emotions affect NPC stats and UI
- NPCs stay consistent with a set personality

---

## How it works (simple version)

Player message → AI model → JSON response → emotion update → UI + chat output

---

## Notes

- Memory is currently short-term (summarized when it gets too long)
- Emotion system is basic but expandable
- Built more as a system experiment than a finished game feature
  
---

## Developer

demovire
