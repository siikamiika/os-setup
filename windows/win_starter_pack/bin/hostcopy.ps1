$path = [system.String]::Join(" ", $args).split("/")[-1]
& icacls $path /inheritance:e
