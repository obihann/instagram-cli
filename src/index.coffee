_ = require 'underscore'
Instagram = require 'instagram-node-lib'
jp2a = require 'jp2a'
moment = require 'moment'

Instagram.set 'client_id', 'b8b6e83a5194471d936670c484375a5d'
Instagram.set 'client_secret', '7a56b096833d41ff98f55369c837ef0d'

Instagram.media.popular {
    complete: (photos) ->
        _.each photos, (photo) ->
            author = photo.user.username
            url =  photo.images.standard_resolution.url
            dateStr = moment(photo.created_time).fromNow()

            renderImage url, author, dateStr
}

renderImage = (url, author, dateStr) ->
    jp2a  [url, "--width=75", "--background=dark", "--color", "-b"], (asciiArt) ->
        console.log asciiArt
        console.log "By: " + author
        console.log dateStr
