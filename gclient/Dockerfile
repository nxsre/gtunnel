FROM swr.cn-south-1.myhuaweicloud.com/bonc/debian:golang_0424

WORKDIR /go/src/gTunnel
ENV PATH=$PATH:/protoc/bin

RUN go version && apt-get update && apt install -y unzip 

# Install protoc and all dependencies
RUN wget https://github.com/protocolbuffers/protobuf/releases/download/v25.7/protoc-25.7-linux-aarch_64.zip &&\
    unzip protoc-25.7-linux-aarch_64.zip -d /protoc &&\
    rm protoc-25.7-linux-aarch_64.zip &&\
    go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.36.6 &&\
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

# Copy over all gtunnel files and directories
COPY go.mod .
COPY gclient/ gclient/.
COPY common/ common/.
COPY grpc/ grpc/.

# Build protoc
RUN cd grpc && ./build_protoc.sh && cd ..

# Get all gtunnel dependencies
RUN go get -d -v ./... && go install -v ./...

# Build client builder
RUN mkdir /output
RUN CGO_ENABLED=0 go build -a -ldflags '-extldflags "-static"' -o gclient/gclient_build gclient/builder/gclient_build.go
ENTRYPOINT ["gclient/gclient_build"]
