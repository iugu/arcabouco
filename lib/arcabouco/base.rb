module Arcabouco

  def self.root
    @@root
  end

  def self.root=(root)
    @@root = root
  end

  def self.gem_root
    @@gem_root
  end

  def self.gem_root=(root)
    @@gem_root = root
  end

  def self.asset_list
      %w(jquery.js app.css app.js vendor.js vendor.css *.png)
  end

end

