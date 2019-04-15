require 'redis'

class RedisHelper
	def initialize(server, port)
		@redis_conn = Redis.new(host: server, port: port)	# Connection is not made yet.
	end

	def set(key, value, return_value = false, request_id)
		if checkConnection(request_id)
			@redis_conn.set(key, value)
		end
	end
	
	def set_with_expire(key, value, ttl, request_id)
		if checkConnection(request_id)
			@redis_conn.set(key, value)
			ttl = (60 * 60 * 24) if ttl.nil? # expire in 24 hours, by default
			@redis_conn.expire(key, ttl)  
		end
	end

	def get(key, request_id)
		if checkConnection(request_id)
			return @redis_conn.get(key)
		end
	end

	def checkConnection(request_id)
		begin
			@redis_conn.ping				# Check Redis server is up.
		rescue StandardError => e
			print_error(e, request_id)
			return false
		else
			return true
		end
	end

	def print_error(e, request_id)
		puts "#{request_id} | Error connecting to Redis server, but the program will continue. (#{e.message})"
		puts "#{request_id} | #{e.backtrace}" unless e.backtrace.nil?
	end
end