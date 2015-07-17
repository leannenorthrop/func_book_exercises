[![](https://travis-ci.org/leannenorthrop/func_book_exercises.svg)](https://travis-ci.org/leannenorthrop/func_book_exercises/builds)

# P Chiusano and R Bjarnason, 'red book' examples and exercises implemented in Swift 1.2

Fascinated by Swift 1.2 and wanting to learn it in depth along with Functional Programming approach I decided to work through [_Functional Programming in Scala_ by P Chiusano and R Bjarnason](http://www.manning.com/bjarnason/). Hints for the exercises can be found in the [answerkey directory](https://github.com/fpinscala/fpinscala/tree/master/answerkey) in the [code repo](https://github.com/fpinscala/fpinscala). If I have time I will work through the book again using Scala and create a Scala branch of this repo.

## Notes to Self

### Swift Stuff

- Need to find a way to typealias with generic parameter.
- Need to find a way to have enums with only generic associated values (Either example in Chapter 4)

### State Actions
A state action is a function which takes a state and returns a tuple of (answer, nextstate). Also easily described as a state transition in a state machine. Combinators are functions that use these state transitions and handle the passing of state from one transition to another (see Page 84).



