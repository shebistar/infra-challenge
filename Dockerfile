# syntax=docker/dockerfile:1

##
## Build
##
FROM golang:1.16-buster AS build

# Set destination for COPY

WORKDIR /app

# Download Go modules

# Copy the source code.

COPY *.go ./

# Build
RUN go build -o /greeter greeter.go

##
## Deploy
##
FROM gcr.io/distroless/base-debian10

WORKDIR /

COPY --from=build /greeter /greeter

EXPOSE 8080

USER nonroot:nonroot

ENV HELLO_TAG="Helloooo World!"

ENTRYPOINT ["/greeter"]
