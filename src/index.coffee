_ = require 'underscore'
jp2a = require 'jp2a'
moment = require 'moment'
express = require 'express'
request = require 'request'
app = express()

renderHtml = (url, cb) ->
    jp2a  [url, "--width=75", "--color", "--fill", "--html-raw"], (asciiArt) ->
        cb asciiArt

streamToWeb = () ->
    app.get "/", (req, res) ->
        request.get "http://instagram-cli.herokuapp.com", (error, response, body) ->
            if !error && response.statusCode == 200
                #res.writeHeader 200, {"Content-Type": "text/html"}
                data = JSON.parse body

                parseForWeb data, (output) ->
                    res.send output

    app.listen(8888)
    console.log "Check out http://localhost:8888 to view your feed"

streamUserToWeb = () ->
    app.get "/", (req, res) ->
        request.get "http://instagram-cli.herokuapp.com/?name="+process.argv[3], (error, response, body) ->
            if !error && response.statuscode == 200
                #res.writeheader 200, {"content-type": "text/html"}
                data = json.parse body

                parseforweb data, (output) ->
                    res.send output

    app.listen(8888)
    console.log "Check out http://localhost:8888 to view your feed"

searchPublic = () ->
    request.get "http://instagram-cli.herokuapp.com", (error, response, body) ->
        data = JSON.parse body
        parseImages data

searchUser = (user) ->
    request.get "http://instagram-cli.herokuapp.com/?user="+user, (error, response, body) ->
        data = JSON.parse body
        parseImages data

parseForWeb = (data, cb) ->
    output = "<div class='ascii' style='font-size: 8px;'>"
    limit = data.length - 1

    _.each data, (photo, index) ->
        url =  photo.images.standard_resolution.url

        renderHtml url, (resp) ->
            output += "<div style='float: left;'><pre>"
            output += resp
            output += "</pre></div>"
        
            if index == limit
                output += "</div>"
                cb output

parseImages = (photos) ->
    _.each photos, (photo) ->
        author = photo.user.username
        url =  photo.images.standard_resolution.url
        dateStr = moment(photo.created_time).fromNow()
        link = photo.link
        renderImage url, author, dateStr, link

renderImage = (url, author, dateStr, link) ->
    jp2a ["--color", "-b", "--fill", url], (asciiArt) ->
        console.log asciiArt
        console.log link
        console.log "By: " + author
        console.log dateStr

switch process.argv[2]
    when "web" then streamToWeb()
    when "webUser" then streamUserToWeb()
    when "user" then searchUser process.argv[3]
    else searchPublic()
