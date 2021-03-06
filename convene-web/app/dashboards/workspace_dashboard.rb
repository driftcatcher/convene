require 'administrate/base_dashboard'

class WorkspaceDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    name: Field::String,
    slug: Field::String,
    id: Field::String.with_options(searchable: false),

    client: Field::BelongsTo,
    branded_domain: Field::String,

    members: Field::HasMany.with_options(class_name: 'Person'),
    rooms: Field::HasMany,

    jitsi_meet_domain: Field::String,

    access_level: Field::String,
    access_code: Field::String,

    created_at: Field::DateTime,
    updated_at: Field::DateTime,

    workspace_memberships: Field::HasMany
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    name
    client
    slug
    branded_domain
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    name
    slug
    branded_domain
    id

    client
    rooms
    members

    jitsi_meet_domain

    access_level
    access_code

    created_at
    updated_at

  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    client
    workspace_memberships
    members
    rooms
    jitsi_meet_domain
    name
    access_level
    access_code
    slug
    branded_domain
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how workspaces are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(workspace)
    workspace.name
  end
end
