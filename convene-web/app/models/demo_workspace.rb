class DemoWorkspace
  # Creates the demo workspace, but only on environments which are
  # configured to include the demo workspace.
  def self.prepare
    return unless Feature.enabled?(:demo)

    Factory.new(Client).find_or_create_workspace!
  end

  # Assembles the DemoWorkspace using the provided Client and Workspace
  # classes.
  class Factory
    attr_accessor :client_repository

    # These are the Rooms we expect the DemoWorkspace to have by default.
    # Our customer team leverages them for their demonstrations of Convene's
    # feature set.
    DEMO_ROOMS = [
      {
        name: "Zee's Desk",
        publicity_level: :listed,
      },
      {
        name: "Vivek's Desk",
        publicity_level: :listed,
      },
      {
        name: "Water Cooler",
        publicity_level: :listed,
      },
      {
        name: "The Ada Lovelace Room",
        publicity_level: :listed,
      },
      {
        name: "Locked Room",
        publicity_level: :listed,
        access_level: :locked,
        access_code: :friends,
      },
    ].freeze

    # @param [ActiveRecord::Relation<Client>] client_repository Where to ensure there
    #  is a Zinc Client with the Convene Demo workspace
    def initialize(client_repository)
      self.client_repository = client_repository
    end

    # Creates the Convene Demo Workspace and Zinc Client if necessary
    def find_or_create_workspace!
      workspace = client.workspaces.find_or_create_by!(name: 'Convene Demo')
      workspace.update!(jitsi_meet_domain: 'convene-videobridge-zinc.zinc.coop',
                        branded_domain: 'convene-demo.zinc.coop',
                        access_level: :unlocked)
      add_demo_rooms(workspace)
      workspace
    end

    private def add_demo_rooms(workspace)
      DEMO_ROOMS.each do |room_properties|
        room = workspace.rooms.find_or_initialize_by(name: room_properties[:name])
        room.update!(room_properties.except(:name))
      end
      workspace
    end

    private def client
      @_client ||= client_repository.find_or_create_by!(name: 'Zinc')
    end
  end
end
