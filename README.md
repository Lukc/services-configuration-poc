
---

# DISCLAIMER

At the moment, this project is still very much a WIP.
Most of the data are there for testing and demonstration purposes.

Both tool, template and other scripts in this repository are still far from being completely ready for practical usage.
Data formats and available APIs may change at any time.

---

This tool is designed to be a common configuration interface for dæmons or applications that depend on each other.
Its intented goal is to make administrating a server easier for non-power-users, even for servers that serve multiple domains and applications.

With it, services are configured as a tree of producers and consumers of services.

## Dependencies

```sh
luarocks install moonscript
luarocks install etlua
luarocks install loadkit
luarocks install argparse
luarocks install luafilesystem
```

## Configuration example

The configuration file (`config.cfg`) is written in Moonscript syntax.

This file describes a tree of services and domains, each of which must be named.

```moon
root {
	service "nginx", {
		-- ...
	}
	service "ssh", {
		-- ...
	}

	domain "test.example", {
		-- ...
	}
	domain "othertest.example", {
		-- ...
	}
}
```

Domains and services can (and probably should) be declared within other domains.

```moon
root {
	service "nginx", {}

	domain "test.example", {
		domain "subtest", {
			-- subtest.test.example configuration here.
		}
	}
}
```

Most services will depend on another service in one way or another.
`services print` will indicate the missing requirements.
To configure them, just add a field that has the name of the requirement in the service definition.

```moon
root {
	service nginx, {}

	domain "test.example", {
		service "some-php-app", {
			php: "/nginx"
		}
	}
}
```

The syntax that describes other services is the following: `domain/service`.
If the service is configured at the root of the tree (and therefor not in any domain), the `domain` part can simply be left blank.

## Configuration troubleshooting

A `print` command is available from the tool’s CLI.
This command prints the tree of domains and services, as well as their status and possible reason for failing.

```sh
moon services.moon print
```

Because each service requirement can be misconfigured for a different reason, they are all printed with their respective status as well.

## Actual generation

The `generate` command (from the tool’s CLI) will generate the configuration.

```sh
moon services.moon generate
```
