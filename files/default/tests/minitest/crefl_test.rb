require File.expand_path('../support/helpers', __FILE__)

describe 'polar2grid::default' do

  include Helpers::Polar2grid

  # Example spec tests can be found at http://git.io/Fahwsw
  it 'creates the polar2grid user' do
    user(node['polar2grid']['user']).must_exist
  end
  
  it 'installs the crefl spas' do
    %w{cviirsv3.1 h5SDS_transfer_rename}.each do |bin|
      file("#{node['polar2grid']['path']}/polar2grid/bin/#{bin}").must_exist.
        with(:owner, node['polar2grid']['user']).
        with(:mode, 0755)
    end
  end
  
end
