module Arcabouco

  class << self
    def mattr_reader(*syms)
      syms.each do |sym|
        raise NameError.new("invalid attribute name: #{sym}") unless sym =~ /^[_A-Za-z]\w*$/
        class_eval(<<-EOS, __FILE__, __LINE__ + 1)
        @@#{sym} = nil unless defined? @@#{sym}
        def self.#{sym}
          @@#{sym}
        end
        EOS

        class_variable_set("@@#{sym}", yield) if block_given?
      end
    end

    def mattr_writer(*syms)
      syms.each do |sym|
        raise NameError.new("invalid attribute name: #{sym}") unless sym =~ /^[_A-Za-z]\w*$/
        class_eval(<<-EOS, __FILE__, __LINE__ + 1)
        @@#{sym} = nil unless defined? @@#{sym}
        def self.#{sym}=(obj)
          @@#{sym} = obj
        end
        EOS

        send("#{sym}=", yield) if block_given?
      end
    end

    def mattr_accessor(*syms, &blk)
      mattr_reader(*syms, &blk)
      mattr_writer(*syms, &blk)
    end
  end

  mattr_accessor :root
  mattr_accessor :gem_root
  mattr_accessor :asset_list
  mattr_accessor :application_name
 
  self.asset_list = %w(app.css app.js vendor.js vendor.css *.png *.jpg *.gif *.mp3 *.wav)
  self.application_name = "Arcabouco Application"

  def self.setup
    yield self
  end

end

