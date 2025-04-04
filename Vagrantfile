Vagrant.configure("2") do |config|
  config.vm.define "control-plane-node-1" do |node|
    node.vm.provider :libvirt do |domain|
      domain.default_prefix = "vagrant-"
      domain.cpus = 2
      domain.memory = 4096
      domain.serial :type => "file", :source => {:path => "/tmp/control-plane-node-1.log"}
      domain.storage :file, :device => :cdrom, :path => "/tmp/metal-amd64.iso"
      domain.storage :file, :size => '4G', :type => 'raw'
      domain.boot 'hd'
      domain.boot 'cdrom'
    end
  end

  config.vm.define "worker-node-1" do |node|
    node.vm.provider :libvirt do |domain|
      domain.default_prefix = "vagrant-"
      domain.cpus = 4
      domain.memory = 6192
      domain.serial :type => "file", :source => {:path => "/tmp/worker-node-1.log"}
      domain.storage :file, :device => :cdrom, :path => "/tmp/metal-amd64.iso"
      # install disk
      domain.storage :file, :size => '50G', :type => 'raw'
      # data disk
      domain.storage :file, :size => '60G', :type => 'raw'
      domain.boot 'hd'
      domain.boot 'cdrom'
    end
  end

  config.vm.define "worker-node-2" do |node|
    node.vm.provider :libvirt do |domain|
      domain.default_prefix = "vagrant-"
      domain.cpus = 4
      domain.memory = 6192
      domain.serial :type => "file", :source => {:path => "/tmp/worker-node-2.log"}
      domain.storage :file, :device => :cdrom, :path => "/tmp/metal-amd64.iso"
      # install disk
      domain.storage :file, :size => '50G', :type => 'raw'
      # data disk
      domain.storage :file, :size => '60G', :type => 'raw'
      domain.boot 'hd'
      domain.boot 'cdrom'
    end
  end

  config.vm.define "worker-node-3" do |node|
    node.vm.provider :libvirt do |domain|
      domain.default_prefix = "vagrant-"
      domain.cpus = 4
      domain.memory = 4096
      domain.serial :type => "file", :source => {:path => "/tmp/worker-node-3.log"}
      domain.storage :file, :device => :cdrom, :path => "/tmp/metal-amd64.iso"
      # install disk
      domain.storage :file, :size => '50G', :type => 'raw'
      # data disk
      domain.storage :file, :size => '60G', :type => 'raw'
      domain.boot 'hd'
      domain.boot 'cdrom'
    end
  end
end
