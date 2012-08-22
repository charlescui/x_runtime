require "erb"

module XRuntime
  class Template
    def initialize(ds, opts={})
      opts.delete_if{|k,v| v == nil}
      opts = {:limit => 100, :offset => 0}.update(opts)
      @ds = ds
      @offset = opts[:offset]
      @limit = opts[:limit]
      @data = @ds.latest(:limit => opts[:limit], :offset => opts[:offset])
    end
    
    def render
      Template.erb.result(binding)
    end
    
    def self.erb
      @erb ||= ERB.new(self.html)
    end
    
    def self.html
      @html ||= IO.read(File.join(File.dirname(__FILE__),'template.erb'))
    end
  end#end of Template
end