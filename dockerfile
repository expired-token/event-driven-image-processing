# BUILD STAGE - building an executable binary | results in a heavy image composed of binary + GO compiler, shell tools, git, package managers...etc
# Base image
FROM golang:1.25-alpine AS build

# Installing git for running command to fetch required GitHub dependencies + ca-certifications for secure HTTP comnection with said repositories  
RUN apk add --no-cache git ca-certificates

# New work directory + Copy dependency files relevant to the project
WORKDIR /app
COPY go.mod go.sum ./

# Download all dependencies
RUN go mod download

# Copy project code into new work directory
COPY main.go .

# Disables CGO tool to force pure Go implementation for network/system calls (without C dependencies) => needed for Lambda's Amazon Linux runtime environment
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o bootstrap main.go

# RUNTIME ENVIRONMENT - building minimal environment with binary file only (AWS provided runtime image takes care of the rest)
# AWS provided image for AWS Lambda based image (small & contains Lambda Runtime Interface Emulator only)
FROM public.ecr.aws/lambda/provided:al2023

# Copy binary file into root
COPY --from=build /app/bootstrap ./bootstrap

# Enable Lambda from using binary file as entrypoint
ENTRYPOINT ["./bootstrap"]
