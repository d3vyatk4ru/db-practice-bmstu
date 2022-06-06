sudo apt-get update -y\
&& sudo apt-get upgrade -y\
&& go mod init db_interaction.go
&& go get github.com/microsoft/go-mssqldb