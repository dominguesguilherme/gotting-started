FROM golang:latest

ARG APP_HOME

ENV GOPATH /opt/go:$GOPATH
ENV PATH /opt/go/bin:$PATH
ENV APP_HOME $APP_HOME

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME
ADD . $APP_HOME

RUN go get -u -v \ 
    github.com/go-delve/delve/cmd/dlv \
    github.com/uudashr/gopkgs/v2/cmd/gopkgs \
    github.com/ramya-rao-a/go-outline \
    github.com/cweill/gotests/... \
    github.com/fatih/gomodifytags \
    github.com/josharian/impl \
    github.com/haya14busa/goplay/cmd/goplay \
    golang.org/x/lint/golint \
    golang.org/x/tools/gopls \
    github.com/cespare/reflex

EXPOSE 8080

RUN go build -o main main.go
CMD ["main"]