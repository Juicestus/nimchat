import jester
import asyncdispatch
import json

routes:
    get "/":
        var db: string = readFile("database.db")
        #var posts = parseJson("[" & db & "]")
        #echo posts
        #echo "[" & db & "]"

        resp Http200, "[" & db & "]", contentType="application/json"
        #resp Http200, $(posts[len(posts)-1]), contentType="application/json"

    post "/":
        let body = request.body
        
        var pdb: string = readFile("database.db")
        pdb = pdb & body & ",\n"
        writeFile("database.db", pdb)
        resp ""

runForever()