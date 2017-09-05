# Elm - Playpen

This is basic elm from the architecture tutorial. I was just making random things and figured it should be in git since I'd like to refer to it later.

Everything in src should be runable with elm-reactor


## Run The Examples

After you [install Elm](http://guide.elm-lang.org/get_started.html), run the following commands in your terminal to download this repo and start a server that compiles Elm for you:

```bash
git clone https://github.com/evancz/elm-architecture-tutorial.git
cd elm-architecture-tutorial
elm-reactor
```

Now go to [http://localhost:8000/](http://localhost:8000/) and start looking at the `examples/` directory. When you edit an Elm file, just refresh the corresponding page in your browser and it will recompile!


## Clock Test

This is me making a game-loop engine. It's pretty dope so far.
Possible addition to the loop engine might be extrapolating between updates.
Updates happen every 30 milliseconds, but we could rerender the view more frequently.
 - Currently the possible issue is that the game CAN play too slowly if an update takes longer than 33 ms

The library I added makes it so we don't call the update function more than once every 33 ms, instead of as fast as the browser can.
BUT! We should render as fast as the browser can, but we need not update that fast. We EXTRAPOLATE the value of the next update in the render
This possibly doesn't work in elm, since the update is bound to the render
This is Fixed update (33 ms) and variable render (as fast as the browser can do it)
This solves our "too slow" problem because we render optimistically whenever possible, making some assumptions.
Worst case scenario - We make bad a assumptions and render something that would collide in the next update.
This can really only mess up a single update. Best option.
Can you separate the update function in elm from the view function?



