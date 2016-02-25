# Nacho 
-----

( **N**ew **A**dd **Cho**oser )

Rails models often have `has_many :through` relations that can be added through various forms. In order to make data
entry more efficient with creating a single record and its related records we can use `nacho` to create multiple forms
in several modals making a single form function as many.

## Requirements
-----

* Rails 4.0+
* jQuery
* Bootstrap 3.0+

## Installation
-----

Add this line to your application's Gemfile:

```ruby
gem 'nacho'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nacho

## Usage
-----

This gem add two new form heplers

    nacho_select
 
and a corresponding tag helper

    nacho_select_tag
    
The javasctip plugin needs to be included  to add to your `application.js` manifest.

    //= require nacho
    
> To create the form for the modal body, the partial needs to be rendered before passing it as an option to the helper. (This may change with the sepration of the view renderer in Rails 5)

### Using the form helper

To create a `nacho` for to add an `Author` to a `Book`, you can do the following.
 
```ruby
= form_for(@book) do |f|
    = f.label :author
    - options = { partial: render('author/form'), value_key: :id, text_key: :name, new_key: :id, selected: @book.author.id }
    = f.nacho_select :author_id, Author.all.pluck(:name, :id), options, {class: 'select-nacho'}
```

The element will have to be initialized via jQurey plugin.

```javascript
$(doocument).on('ready page:change', function(){
    $('.select-nacho').nacho();
});
```

### Helper options

The options hash options can take the folloing values:

- ``:include_blank``  should include a blank in the select options, forced to true if the choices is empty
- ``:new_option_text`` The text to display on the option to trigger the modal
- ``:value_key`` The key for the JSON options hash array that the `<option>` value will use
- ``:text_key`` The key for the JSON options hash array that the `<option>` will display
- ``:new_key`` The key for the JSON top level key that has the value for the newly created item
- ``:modal_title`` The title of the modal that will be displayed
- ``:partial`` The form partial for the modal body. Has to pre-rendered like `partial: render('author/form')`
 
### Javascript events


``nacho-select:updated`` is triggered on the select element that was just updated via adding a new record.


### Controller responses for adding a new record

The jQurey plugin submits the form via AJAX.
 
> The plugin addes `"remote"="true"` to the inner form at initialization.

The controller need to have a JSON responder on the `create` action for the target model.

Here is an example of what the `Author` controller.

```ruby
def create
    @author = Author.new(author_params)
    
    respond_to do |format|
      if @author.save
        format.html { redirect_to author, notice: 'Author was successfully created.' }
        format.json {
          @authors = Author.all
        }
      else
        format.html { render :new }
        format.json { render json: @author.errors, status: :unprocessable_entity }
      end
    end
end
```

And the corresponding jBuilder template, `create.json.jbuilder`.

```ruby
json.id @author.id
json.options do
  json.array!(@authors) do |author|
    json.extract! author, :id, :name
  end
end
```

The jQuery plugin has to recieve the JSON response data with a key with value of the new item and an `options` array with the data to repopulate the `select` options.

Similar to:

```json
{
	id: <id of new record>,
    options: [
    	{
          id: ...,
          name: ...
        },
        ...
    ]
}
```

With the helper options

```json
{
	<new_key>: <id of new record>,
    options: [
    	{
          <new_key>: ...,
          <text_key>: ...
        },
        ...
    ]
}
```

## Development
-----

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing
-----

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/nacho. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License
-----

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).