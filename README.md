#Butler
Turn:

`bundle exec rails server`
`foreman run python app.py db upgrade`
`...`

into:

`butler run` or `butler build` or `butler test`.

Basically anything you do every day, let the Butler do it.

##Installation

Butler is easiest installed via homebrew:

    > brew install michaeldfallen/formula/butler

Then run `butler --init` to create a sample butlerfile and get started.

###Bash and Zsh completion

To enable completion add the following to your `~/.bashrc` or `~/.zshrc`:

    source "$(butler --init-completion)"

That will load the correct completion files for your shell.

##Usage

Create a butlerfile to define your commands

    [command]: [shell command to run]

then tell butler to do it

    > butler [command]
    Certainly...

###Longer scripts - coming soon

For longer scripts just drop them in a `bin` folder

    project/
      bin/
        complexbuild
      ..

Butler will know what to do

    > butler complexbuild
    Aye, sir...

##License

Butler is licensed under the MIT license.

See [LICENSE] for the full license text.

##Credits

Inspired by
[Foreman] by [David Dollar] [@ddollar]
and
[Shoreman] by [Chris Mytton] [@chrismytton]

[Foreman]: https://github.com/ddollar/foreman
[David Dollar]: https://github.com/ddollar
[@ddollar]: https://twitter.com/ddollar
[Shoreman]: https://github.com/chrismytton/shoreman
[Chris Mytton]: https://github.com/chrismytton
[@chrismytton]: https://twitter.com/chrismytton
[LICENSE]: https://github.com/michaeldfallen/butler/blob/master/LICENSE
