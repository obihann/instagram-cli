_ = require 'underscore'
Instagram = require 'instagram-node-lib'
jp2a = require 'jp2a'
moment = require 'moment'
express = require 'express'
app = express()

Instagram.set 'client_id', 'b8b6e83a5194471d936670c484375a5d'
Instagram.set 'client_secret', '7a56b096833d41ff98f55369c837ef0d'

renderHtml = (url, cb) ->
    jp2a  [url, "--width=75", "--color", "--fill", "--html-raw"], (asciiArt) ->
        cb asciiArt

streamToWeb = () ->
    app.get "/", (req, res) ->
        Instagram.media.popular {
            complete: (data, pagination) ->
                res.writeHeader 200, {"Content-Type": "text/html"}
                res.write "<div class='ascii' style='font-size: 8px;'>"
                _.each data, (photo, index) ->
                    url =  photo.images.standard_resolution.url

                    renderHtml url, (resp) ->
                        res.write "<div style='float: left;'><pre>"
                        res.write resp
                        res.write "</pre></div>"

                    if index == data.length
                        res.write "</div>"
                        res.end() 
        }

    app.listen(8888)

streamToWeb()
