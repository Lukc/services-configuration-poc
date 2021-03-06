
Object = require "yunoconfig.configuration.object"

class extends Object
	new: (name, opt) =>
		super name, opt

		@type = "domain"

		@domains = {}
		@services = {}
		@host = opt.host or nil

		for i = 1, #opt
			child = opt[i]

			switch child.type
				when "domain"
					table.insert @domains, child
				when "service"
					table.insert @services, child

	getDomainName: =>
		if @parent
			parentName = @parent\getDomainName!

			if parentName
				self.name .. "." .. parentName
			else
				self.name
		else
			self.name or ''

	subdomains: =>
		coroutine.wrap ->
			coroutine.yield self

			for domain in *@domains
				for domain in domain\subdomains!
					coroutine.yield domain

	getHost: =>
		unless @host
			return if @parent
				@parent\getHost!
			else
				nil

		for host in *@context.definedHosts
			if host.name == @host
				return host

	__tostring: =>
		"<configuration.domain: #{@name}>"

