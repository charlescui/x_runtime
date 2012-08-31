module XRuntime
  module Utils
    class << self
      def to_hash(data)
        case data
        when Array
          array_hashify.call(data)
        end
      end
  
      def array_hashify
        lambda { |array|
          hash = Hash.new
          array.each_slice(2) do |field, value|
            hash[field] = value
          end
          hash
        }
      end
      
      PROBELATESTFLAG = "XX-Runtime-Latest"
      PROBEFLAG = "XX-Runtime"
      # Rails : XRuntime::Utils.probe(headers)
      # Sinatra : XRuntime::Utils.probe(headers)
      
      # for Nginx log:
      # log_format timing '$remote_addr - $remote_user [$time_local] "$status" $request "$http_user_agent" '
      #                           'upstream_response_time $upstream_response_time '
      #                           'msec $msec request_time $request_time probe $upstream_http_xx_runtime';
      def probe(headers={})
        headers[PROBEFLAG] = "0" unless headers[PROBEFLAG]
        
        if headers[PROBELATESTFLAG]
          last_probe = headers[PROBELATESTFLAG].to_f
          headers[PROBEFLAG] += ",#{"%06f"%(Time.now.to_f - last_probe)}"
        end
        
        headers[PROBELATESTFLAG] = Time.now.to_f.to_s
      end
    end
  end
end