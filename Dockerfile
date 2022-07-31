FROM public.ecr.aws/docker/library/golang:1.18

WORKDIR /usr/src/app

# pre-copy/cache go.mod for pre-downloading dependencies and only redownloading them in subsequent builds if they change
#COPY go.mod go.sum ./
#RUN go mod download && go mod verify

#aCOPY . .
#RUN go build -v -o /usr/local/bin/app ./...

COPY *.go ./
EXPOSE 80

# check security fixes

RUN apt-get update && apt-get install -y --no-install-recommends git mercurial openssh-client subversion procps && rm -rf /var/lib/apt/lists/* && set -eux; apt-get update; apt-get install -y --no-install-recommends ca-certificates curl netbase wget ; rm -rf /var/lib/apt/lists/* 

RUN go build -o /greeter greeter.go

ENV HELLO_TAG="Hellooooo World!"

CMD [ "/greeter" ]

