#
# Cookbook Name:: polar2grid
# Recipe:: default
#
# Copyright (C) 2013 Scott Macfarlane
# 
# All rights reserved - Do Not Redistribute
#


user node['polar2grid']['user']

ark 'polar2grid' do
  url node['polar2grid']['url']
  path node['polar2grid']['path']
  owner node['polar2grid']['user']
  action :put
end

template "/etc/profile.d/polar2grid_env.sh" do
  source "polar2grid_env.sh.erb"
end
