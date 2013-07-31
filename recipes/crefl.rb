
remote_file "#{Chef::Config[:file_cache_path]}/#{node['polar2grid']['crefl']['package']}" do
  source "#{node['polar2grid']['crefl']['url']}/#{node['polar2grid']['crefl']['package']}"
  action :create_if_missing
end

execute "Extract CREFL SPA" do
  cwd Chef::Config[:file_cache_path]
  command "tar xvf #{node['polar2grid']['crefl']['package']}"
  not_if {::File.exists? "#{Chef::Config[:file_cache_path]}/SPA/CVIIRS/VERSIONLOG"}
end


node['polar2grid']['crefl']['patches'].each do |patch|
  remote_file "#{Chef::Config[:file_cache_path]}/#{patch}" do
    source "#{node['polar2grid']['crefl']['url']}/#{patch}"
    action :create_if_missing
  end
  
  execute "Patch CREFL SPA" do
    cwd Chef::Config[:file_cache_path]
    command "tar xvf #{patch}"
    not_if {::File.exists? "#{Chef::Config[:file_cache_path]}/SPA/CVIIRS/CVIIRS_1.0_SPA_1.0_PATCH_1_VERSIONLOG"}
  end
end

directory "#{node['polar2grid']['path']}/polar2grid/lib/crefl" do
  action :create
  owner node['polar2grid']['processing']
  recursive true
end

%w{cviirs preprocess}.each do |dir|
  execute "Copy binaries to polar2grid install" do
    cwd Chef::Config[:file_cache_path]
    command "cp -R SPA/CVIIRS/algorithm/#{dir.upcase} #{node['polar2grid']['path']}/polar2grid/lib/crefl/#{dir}"
    not_if {::File.exists? "#{node['polar2grid']['path']}/polar2grid/lib/crefl/#{dir}"}
  end
end

link "#{node['polar2grid']['path']}/polar2grid/bin/cviirsv3.1" do
  to "#{node['polar2grid']['path']}/polar2grid/lib/crefl/cviirs/cviirsv3.1"
  owner node['polar2grid']['user']
end

link "#{node['polar2grid']['path']}/polar2grid/bin/h5SDS_transfer_rename" do
  to "#{node['polar2grid']['path']}/polar2grid/lib/crefl/preprocess/h5SDS_transfer_rename"
  owner node['polar2grid']['user']
end

template "#{node['polar2grid']['path']}/polar2grid/bin/run_viirs_crefl.sh" do
  source "run_viirs_crefl.sh.erb"
  mode 0755
  owner node['polar2grid']['user']
end

execute "Set correct correct permissions" do
  cwd "#{node['polar2grid']['path']}/polar2grid"
  command "chown -R #{node['polar2grid']['user']} ."
end