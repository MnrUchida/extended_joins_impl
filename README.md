# ExtendedJoinsImpl

Syntactic sugar for using a subquery and left outer join in ActiveRecord

## Installation

Add this line to your application's Gemfile:

    gem 'extended_joins_impl'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install extended_joins_impl

## Usage
In these case
    class User < ActiveRecord::Base
      belongs_to :type
      has_many :user_notes,
               class_name: "Note",
               primary_key: :code,
               foreign_key: :user_code

    end

    class Type < ActiveRecord::Base
    end

    class Note < ActiveRecord::Base
    end

    # SELECT users.* FROM users INNER JOIN (SELECT * FROM types) types ON users.type_id = types.id
    User.scoped.extended_joins(:inner, Type.scoped)

    # SELECT users.* FROM users LEFT OUTER JOIN (SELECT * FROM types) types ON users.type_id = types.id
    User.scoped.extended_joins(:outer, Type.scoped)

    # SELECT users.* FROM users INNER JOIN (SELECT * FROM types WHERE id = 3) types ON users.type_id = types.id
    User.scoped.extended_joins(:inner, Type.where(id: 3)

    # SELECT users.* FROM users INNER JOIN (SELECT * FROM types) user_types ON users.type_id = user_types.id
    User.scoped.extended_joins(:inner, Type.scoped, as: "user_types")

    # SELECT users.* FROM users INNER JOIN (SELECT * FROM notes) notes ON users.code = notes.user_code
    User.scoped.extended_joins(:inner, Note.scoped, on: {code: :user_code})

    # SELECT users.* FROM users INNER JOIN (SELECT * FROM notes) notes ON users.id = notes.user_id AND notes.user_code = 3
    User.scoped.extended_joins(:inner, Note.scoped, where: {user_code: 3})

    # if alias name is same as association name
    # SELECT users.* FROM users INNER JOIN (SELECT * FROM notes) notes ON users.code = notes.user_code
    User.scoped.extended_joins(:inner, Note.scoped, as: "user_notes")

## Contributing

1. Fork it ( http://github.com/<my-github-username>/extended_joins_impl/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
