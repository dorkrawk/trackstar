# Trackstar 🏃‍♂️

[![Gem Version](https://badge.fury.io/rb/trackstar.svg)](https://badge.fury.io/rb/trackstar)

**Track things. Like a star!**

Trackstar is a simple, command line based practice tracker. It creates human-readable Markdown files for every entry in your log.

Use the built in stats functionality to get some insights. If you need to edit or review entries, just open up the files.

## Installation

```
$ gem install trackstar
```

## Usage

### Create a new Trackstar log

```
$ trackstar -n "Guitar Practice"
```

This will create a directory for your log, a trackstar.yaml config file, and a directory called `posts` where all of your entries will go.

### Create a new post in an existing Trackstar log

To write new posts in your log, you will to run the `trackstar` command from within your log directory. When you write a new log, a new Markdown file will be created in the `posts` directory.

```
$ trackstar
New Post For Aug 19 2017 10:09 pm:
---------------------
subject:
...
```

### Get log stats
```
$ trackstar -s
```

### List recent posts
```
$ trackstar -l # lists the 10 most recent posts
...
$ trackstar -l 5 # lists the 5 most recent posts
...
```

### Need more help?

```
$ trackstar -h
```

## Customisation

### Editing Post Fields

You can change the fields used in your Trackstar log by editing the `post_fields` values in the `trackstar.yaml` config file. The format is:
```yaml
post_fields:
  field_name: conversation_method
```
where `conversation_method` is a Ruby String method for type conversion.

### Editing Post Formatting

You can add formatting to the post Markdown by editing the `post_formatting` values in the `trackstar.yaml` config file. The format is:
```yaml
post_formatting:
  field_name: formatting_method
``` 
where `formatting_method` is a method implemented in the `Trackstar::Post` class to add formatting after a field.

Currently supported formatting methods:
- `hr_after`: Adds a horizontal rule after the field

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Testing

To run tests:
```
$ rake test
```

## Contributing

1. Fork it ( https://github.com/dorkrawk/trackstar/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
