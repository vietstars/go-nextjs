This is a [Next.js](https://nextjs.org/) project bootstrapped with [`create-next-app`](https://github.com/vercel/next.js/tree/canary/packages/create-next-app).

## Getting Started


.dockerignore
node_modules
.next
.vscode
*.DS_Store
.gitignore
README.md
.dockerignore
LICENSE
.docker
.gitlab
.git

-------

package main

import (
    "fmt"
    "github.com/gorilla/mux"
    "io"
    "log"
    "net/http"
    "os"
)

func UploadFile(w http.ResponseWriter, r *http.Request) {
    file, handler, err := r.FormFile("file")
    fileName := r.FormValue("file_name")
    if err != nil {
        panic(err)
    }
    defer file.Close()

    f, err := os.OpenFile(handler.Filename, os.O_WRONLY|os.O_CREATE, 0666)
    if err != nil {
        panic(err)
    }

    defer f.Close()
    _, _ = io.WriteString(w, "File "+fileName+" Uploaded successfully")
    _, _ = io.Copy(f, file)
}

func homeLink(w http.ResponseWriter, r *http.Request) {
    _, _ = fmt.Fprintf(w, "Welcome home!")
}

func main() {
    router := mux.NewRouter().StrictSlash(true)
    router.HandleFunc("/", homeLink)
    router.HandleFunc("/file", UploadFile).Methods("POST")
    log.Fatal(http.ListenAndServe(":8081", router))
}

---------

curl -X POST \
  http://localhost:8081/file \
  -H 'Accept: */*' \
  -H 'Accept-Encoding: gzip, deflate' \
  -H 'Cache-Control: no-cache' \
  -H 'Connection: keep-alive' \
  -H 'Content-Length: 4251' \
  -H 'Content-Type: multipart/form-data; boundary=--------------------------489143350034706567613009' \
  -H 'Host: localhost:8081' \
  -H 'Postman-Token: fea94e80-8294-4f0b-87bf-09b706eddac8,1bbb735b-f88d-4194-a1b5-f8cd90189545' \
  -H 'User-Agent: PostmanRuntime/7.17.1' \
  -H 'cache-control: no-cache' \
  -H 'content-type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW' \
  -F file=@/Users/vasubabujinagam/Documents/protobuf-3.9.2/CONTRIBUTORS.txt \
  -F file_name=file1
