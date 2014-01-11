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
        request.get "http://localhost:3131/", (error, response, body) ->
            if !error && response.statusCode == 200
                res.writeHeader 200, {"Content-Type": "text/html"}
                res.write "<div class='ascii' style='font-size: 8px;'>"
               
                data = JSON.parse body
                
                _.each data, (photo, index) ->
                    url =  photo.images.standard_resolution.url

                    renderHtml url, (resp) ->
                        res.write "<div style='float: left;'><pre>"
                        res.write resp
                        res.write "</pre></div>"

                    if index == data.length
                        res.write "</div>"
                        res.end() 

    app.listen(8888)

streamUserToWeb = () ->
    app.get "/", (req, res) ->
        request.get "http://localhost:3131/?name="+process.argv[3], (error, response, body) ->
            if !error && response.statusCode == 200
                #res.writeHeader 200, {"Content-Type": "text/html"}
                data = JSON.parse body

                parseForWeb data, (output) ->
                    res.send output

    app.listen(8888)

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

switch process.argv[2]
    when "web" then streamToWeb()
    when "webUser" then streamUserToWeb()
