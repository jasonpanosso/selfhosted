Vagrant.configure("2") do |config|
  config.vm.define "control-plane-node-1" do |node|
    node.vm.provider :libvirt do |domain|
      domain.cpus = 2
      domain.memory = 2048
      domain.serial :type => "file", :source => {:path => "/tmp/control-plane-node-1.log"}
      domain.storage :file, :device => :cdrom, :path => "/tmp/metal-amd64.iso"
      domain.storage :file, :size => '4G', :type => 'raw'
      domain.boot 'hd'
      domain.boot 'cdrom'
    end
  end

    config.vm.define "worker-node-1" do |node|
      node.vm.provider :libvirt do |domain|
        domain.cpus = 4
        domain.memory = 8192
        domain.serial :type => "file", :source => {:path => "/tmp/worker-node-1.log"}
        domain.storage :file, :device => :cdrom, :path => "/tmp/metal-amd64.iso"
        domain.storage :file, :size => '50G', :type => 'raw'
        domain.boot 'hd'
        domain.boot 'cdrom'
      end
    end
end
