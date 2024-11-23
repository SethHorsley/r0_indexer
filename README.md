# R0 Indexer 🔍
> Keep track of your Rails views, controllers, and routes with ease! 🚀

## What is R0 Indexer? 🤔

R0 Indexer is a Rails gem that helps you index and query your project's structure. It creates a searchable database of your views, controllers, and routes, making it easier to understand and navigate your Rails application.

## Features ✨

- 📁 Indexes all views and their relationships
- 🎮 Maps controllers to their actions
- 🛣️ Tracks route definitions
- 🔎 Powerful query interface
- 🚀 Fast SQLite-based search
- 🎯 Simple CLI commands

## Installation 💿

Add this line to your application's Gemfile:

```ruby
gem 'r0_indexer'
```

Then execute:

```bash
$ bundle install
$ rails generate r0_indexer:install
```

## Usage 🛠️

### CLI Commands

Index your repository:

```bash
$ r0 index
```

Search for files:

```bash
$ r0 search "posts"
```

Find controller-related files:

```bash
$ r0 controller "posts"
```

### Ruby API

```ruby
# Query the index
query = R0Indexer::Query.new

# Find all files related to PostsController
results = query.find_by_controller('posts')

# Find all index actions
index_actions = query.find_by_action('index')

# Search by path
views = query.find_by_path('views/posts')
```

## How It Works 🔧

R0 Indexer creates a `.r0` directory in your Rails project root and maintains a SQLite database of your project's structure. It indexes:

- 📝 View templates and partials
- 🎮 Controller actions and their relationships
- 🛣️ Route definitions
- 📊 File metadata and timestamps

## Configuration 🎛️

The gem works out of the box with zero configuration needed! The `.r0` directory is automatically added to your `.gitignore`.

## Best Practices 💡

- Run `r0 index` after significant changes to your codebase
- Use specific searches to narrow down results
- Keep your database up to date for accurate results

## Contributing 🤝

1. Fork it
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -am 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Create a Pull Request

## License 📄

This gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
