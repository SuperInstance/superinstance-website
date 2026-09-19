# Gesture geometry across the fleet — one idea, six repos

> A tensor approximates a **function**. The SuperInstance fleet approximates the
> **abstraction** — the shape of the motion between states. This is the story of
> one idea carried, as running code, across six repositories.

## The idea, in one paragraph

A function approximator learns a **point**: give it a state, it returns a value.
That is enormously useful and it is not the whole story, because the things we
care about *move*. A phrase, a room's mood, a conversation, a cell, a converging
model — each traces a **path** through some abstraction space, and a path has
geometry a snapshot cannot hold. Read that geometry **order by order**:

| Order | Name | Reads | Zero when… |
|---|---|---|---|
| 1st | `heading` / `arc_length` | direction of travel (a velocity, the **`d_mu`**) and distance covered | it isn't moving |
| 2nd | `bending_energy` | **curvature** — how hard it turns *within* a plane | it moves in a straight line |
| 3rd | `twist_energy` | **torsion** — how hard it turns *out of* that plane, into a new dimension | its whole motion stays in one plane |

Plus `planarity` (the scale-free inverse of twist) and a scale/offset-invariant
`gesture_distance` for comparing *how two things move*, not where they are.

## The third order is the fleet's oldest law

Curvature rearranges what is already there; **torsion reaches what was not**. A
gesture only twists when its turning leaves the plane it was turning in — when the
next move opens a direction the last two did not span. That is
[**twist-engine**](https://github.com/SuperInstance/twist-engine)'s thesis exactly:

> *Layers + deliberate offset → interference → emergence. No new atoms — a new
> angle. The property is in the twist.*

`twist_energy` is that law turned into a number you can read off anything that
moves.

## The six repos that now speak it

| Repo | The gesture is… | The reader |
|---|---|---|
| [musician-soul](https://github.com/SuperInstance/musician-soul) | a phrase's path through a 32-D feature space | `AbstractionSpline.twist_energy` |
| [elephant](https://github.com/SuperInstance/elephant) | a room's path through its mood dials | `VibeTrajectory.twist_energy` |
| [tensor-midi](https://github.com/SuperInstance/tensor-midi) | a conversation's path through SWMIDI events | `Clip.twistEnergy` |
| [quilt](https://github.com/SuperInstance/quilt) | any cell's motion through state space | `@quilt/core`'s `Gesture` (the neutral primitive) |
| [federated-tinyml-vessel](https://github.com/SuperInstance/federated-tinyml-vessel) | a federated model's per-round parameter path | `convergence_geometry` |
| [twist-engine](https://github.com/SuperInstance/twist-engine) | five live-ledger substrates | the origin of the law (`GESTURE_BRIDGE.md`) |

Each takes an ordered sequence of vectors and exposes the same three orders and
the same vocabulary — so a melody, a mood, a dialogue, a cell, and a converging
model can now be compared as *motions*, across coordinate systems that otherwise
never touch. quilt holds the neutral primitive, because the substrate is where the
fleet's abstractions compose; the others specialize it in their own domains.

## Why it reads as one system

- **A melody** with high twist keeps opening new dimensions of style rather than
  ornamenting one.
- **A room** with high twist keeps recruiting a new mood dial rather than swinging
  between two.
- **A conversation** with high twist reaches a genuinely new axis rather than
  pacing the same argument.
- **A federated model** with high twist converges by opening new directions of
  parameter space rather than refining one plane.

Different substrates, one geometry. A tensor approximates a function; together we
approximate the abstraction — and the third order of that abstraction is the
twist.

---

*Honest edges: `twist_energy` is a discrete, dimension-agnostic generalization of
torsion (the unsigned angle each step leaves the osculating plane), not the
classical signed 3-space scalar; it needs ≥4 readings. And a tempting reading —
that a federated model's twist tracks non-IID skew — was checked and did **not**
show a clear effect at moderate skew, so it ships as an observable of the
convergence path, not a validated detector. The lens is real; the reading is
yours.*
