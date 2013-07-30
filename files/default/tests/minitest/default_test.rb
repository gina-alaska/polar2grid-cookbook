require File.expand_path('../support/helpers', __FILE__)

describe 'polar2grid::default' do

  include Helpers::Polar2grid

  # Example spec tests can be found at http://git.io/Fahwsw
  it 'creates the polar2grid user' do
    user(node['polar2grid']['user']).must_exist
  end
  
  it 'installs polar2grid' do
    file("#{node['polar2grid']['path']}/polar2grid/bin/viirs2awips.sh").must_exist.
      with(:owner, node['polar2grid']['user']).
      with(:mode, 0755)
  end
  
  it 'sets up the polar2grid environment' do
    file('/etc/profile.d/polar2grid.sh').must_exist.with(:owner, 'root').with(:mode, 0644)
  end

end
