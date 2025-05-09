FROM golang:1.24.2 AS gtunbase

WORKDIR /go/src/gTunnel
ENV PATH=$PATH:/protoc/bin:$GOPATH/bin

# We need unzip to install protoc
RUN apt update && apt install -y \
	unzip

# Install protoc and all dependencies
RUN wget https://github.com/protocolbuffers/protobuf/releases/download/v25.7/protoc-25.7-linux-aarch_64.zip &&\
unzip protoc-25.7-linux-aarch_64.zip -d /protoc &&\
rm protoc-25.7-linux-aarch_64.zip &&\
go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.36.6 &&\
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

# Copy over all gtunnel files and directories
COPY go.mod .
COPY go.sum .
COPY gserver/ gserver/.
COPY common/ common/.
COPY grpc/ grpc/.

# Build all protoc files
RUN cd grpc && ./build_protoc.sh && cd ..

# Get all gtunnel dependencies
RUN go get -d -v ./... && go install -v ./...

# The image for building gtuncli
FROM gtunbase AS gtuncli
RUN mkdir gtuncli
WORKDIR /go/src/gTunnel/gtuncli
CMD go build -o /build/gtuncli gtuncli.go

# The gserver image used to run the gtunnel server
FROM gtunbase AS gtunserver-build
RUN apt install -y openssl
#	gcc-mingw-w64-i686 \
#	gcc-mingw-w64-x86-64
RUN mkdir tls && openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out tls/cert -subj "/C=/ST=/L=/O=/CN=" -keyout tls/key
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o gserver/gserver gserver/gServer.go

FROM alpine:3.21 AS gtunserver-prod
RUN apk --update add redis
COPY --from=gtunserver-build /go/src/gTunnel/gserver/gserver .
CMD ./gserver



# The gserver debug image used for debugging gtunnel server
FROM gtunserver AS gtunserver-debug
RUN go get -u github.com/go-delve/delve/cmd/dlv
CMD ["dlv", "--headless", "--listen=0.0.0.0:2345", "--api-version=2", "debug", "gserver/gServer.go"]
