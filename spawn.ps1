function Spawn-Node {
    
	param (
        $name
    )
		
	docker build . --tag "ubuntu:custom"
	docker run -d --name "$name" --restart unless-stopped --privileged -p 22 ubuntu:custom
	docker exec -t --user ubuntu "$name" '/scripts/keypair.sh'
	docker cp "$(echo $name):/home/ubuntu/.ssh/id_ed25519" ./$name.id

}