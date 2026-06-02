# Huanshankeji Kotlin coding and software engineering guidelines
These coding guidelines are laid down to promote **efficiency** and **security** (fewer bugs) of software development mainly in Kotlin in Huanshankeji. They are not final and may evolve with actual requirements in our work.

## Conciseness and efficiency
Note: *Kotlin officially promotes readability rather than conciseness. Conciseness is included as the first section not because it's important but because it's relatively easier to understand and stick to.*

1. Conciseness over verboseness. Simplify code with IDE suggestions when necessary.
1. Don't optimize concise code unless necessary.
   > Programmers waste enormous amounts of time thinking about, or worrying about, the speed of noncritical parts of their programs, and these attempts at efficiency actually have a strong negative impact when debugging and maintenance are considered. We should forget about small efficiencies, say about 97% of the time: premature optimization is the root of all evil. Yet we should not pass up our opportunities in that critical 3%. -- Donald Knuth

   (referred to as *root of all evil*)
1. Comment only where necessary.

## Modularity and abstraction
1. Try not to copy code (stick to DRY). use (inline) higher-order functions and interfaces and abstract classes with abstract methods. See FP and OOP principles for more details.
   1. Utilize Kotlin Multiplatform to share as much code as possible among different platforms.
1. Clear names for packages, files, and global definitions in English. Comment where names are not enough to convey their meanings.

### Make code type-safe, readable, analyzable, and optimizable
1. Avoid reflections. Especially, don't use reflections based on names.
1. Use Kotlin DSL for configurations. Prefer Kotlin DSL over XML where feasible.
1. Use annotation processing (KSP) only when there is no equivalent and simple way provided by the language to do it without annotation processing.
1. Try to follow some ideas of type-driven development that are implementable in Kotlin when building the architecture.

## FP (functional programming) principles
1. Functional over imperative (corresponds to *Conciseness and efficiency*), except where imperative does make a big difference in speed in a key spot, especially in the sense of asymptotic computational complexity (corresponds to *root of all evil*). This is especially important for global definitions.
    1. Pure over impure.
    1. `val`s over `var`s.
    1. Collection higher-order functions (`map`, `filter`, `reduce`, etc.) over self-implemented ones. Use lazy sequences or Java 8 streams properly where needed.
    1. When self-implementing, foreach loops over recursion (`tailrec`) over other loops. (though recursion is more functional, on JVM it's often not as efficient)
1. FP over OOP when they both provide solutions of roughly the same verbosity to a problem.

## OOP (object-oriented programming) principles
1. Try not to override non-abstract (open) methods but only to implement abstract methods. When you do have to do it, follow the *Liskov Substitution Principle*.
1. Interfaces over abstract classes.
1. Try to avoid casts and object type checks (`is`/`instanceof`) that don't reflect dynamic dispatch, except for pattern-matching a sealed class in a when expression.

## Format and syntax
1. Format your code (and comments) with the IDE (IntelliJ IDEA).

## Software engineering concepts
You should be familiar with these software engineering concepts and apply them when needed, though some of them are becoming less meaningful with the evolution of programming languages and under the impact of the functional paradigm:
1. SOLID
1. separation of concerns
1. high cohesion, loose coupling
1. single source of truth
