_ = require 'underscore'
Instagram = require 'instagram-node-lib'
jp2a = require 'jp2a'
moment = require 'moment'

Instagram.set 'client_id', 'b8b6e83a5194471d936670c484375a5d'
Instagram.set 'client_secret', '7a56b096833d41ff98f55369c837ef0d'

parseImages = (photos, pagination) ->
    _.each photos, (photo) ->
        author = photo.user.username
        url =  photo.images.standard_resolution.url
        dateStr = moment(photo.created_time).fromNow()
        link = photo.link

        renderImage url, author, dateStr, link

renderImage = (url, author, dateStr, link) ->
    jp2a  [url, "--width=75", "--background=dark", "--color", "-b"], (asciiArt) ->
        console.log asciiArt
        console.log link
        console.log "By: " + author
        console.log dateStr

searchPublic = () ->
    Instagram.media.popular {
        complete: parseImages
    }

searchUser = (user) ->
    Instagram.users.search {
        q: user,
        complete: (data, pagination) ->
            Instagram.users.recent {
                user_id: data[0].id,
                complete: parseImages
            }
    }


switch process.argv[2]
    when "user" then searchUser process.argv[3]
    else searchPublic()
