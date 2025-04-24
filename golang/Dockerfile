FROM ACME/linux-arm64-musl:20250424-a3b42cd 

#RUN apt install -y golang  bison flex bsdmainutils && curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer | bash && \
#    bash -c "source /root/.gvm/scripts/gvm && CC=/usr/bin/gcc gvm install go1.20.14 && gvm use go1.20.14 && CC=/usr/bin/cc gvm install go1.22.12 && gvm use go1.22.12 && CC=/usr/bin/cc gvm install go1.24.2 && gvm use go1.24.2 --default"

RUN wget https://go.dev/dl/go1.24.2.linux-arm64.tar.gz && rm -rf /usr/local/go && tar -C /usr/local -xzf go1.24.2.linux-arm64.tar.gz
ENV GOROOT=/usr/local/go
ENV GOPATH=/opt/go
ENV PATH=$PATH:$GOROOT/bin:$GOPATH/bin
