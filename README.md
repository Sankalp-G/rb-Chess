# rb-Chess
A fully featured Chess game made in Ruby! Along with a myriad of tests.

This project was a part of The Odin Project Curriculum, you can find the project specs [here](https://www.theodinproject.com/lessons/ruby-ruby-final-project)

## Demo
![chess_demo](https://github.com/Sankalp-G/rb-Chess/assets/38313659/e4a3dfff-fb1b-4511-8639-4d06ddc639d8)

## Try it yourself
Play it online on replit: https://replit.com/@SankalpGawali/rb-Chess

Or run it locally:
- Clone this repo: `git clone https://github.com/Sankalp-G/rb-Chess`
- Make sure ruby is install, This project was built using Ruby 3.1.2
- Run `ruby main.rb`
- To use the tests install the rspec gem or run `bundle install`
- Then just run `rspec` in the project directory

## Features
- Play a two player chess match
- Save and Load your game
- Implemented various possible game over conditions
- Lovely Unicode and ANSI color based chess board
- Complex mechanics such as castling, pawn promotion and en passant
- Comprehensive test suite using rspec
- Over 125 tests!

## Gameover Conditions:
- Checkmate
- Stalemate
- Insufficient Material
- 50 Move rule
- Threefold repitition

(Yes, all of these are part of the official chess ruleset)

## Final Thoughts
This is the single biggest project I've ever undertaken, primarily due to the extensive size and complexity of the systems that needed to be implemented and integrated. Completing this project required a tremendous amount of time due to its scope and the fact that I began working on it just before my entrance exams and the start of my first year of college, which significantly limited my available development time.

Nevertheless, I am proud to have successfully worked on and completed this project. As it provided me with valuable opportunities to learn and reinforce important concepts, such as planning, modularization and proper testing, which played a crucial role in achieving project completion.

## Possible Future additions:
Various things I feel could be further improved upon or implemented:
- Ability to play against an AI / single player games
- Allowing the player to name their save games
- Certain classes are fairly long and could be better organized
- In particular the Turn class is fairly convoluted and could use refactoring
- Better instructions as part of the UI while making moves
- Unit tests, as most tests in this project are akin to integration tests

<br>

Source: https://github.com/Sankalp-G/rb-Chess
