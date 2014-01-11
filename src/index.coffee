_ = require 'underscore'
Instagram = require 'instagram-node-lib'
express = require 'express'
app = express()

Instagram.set 'client_id', process.env.INSTAGRAMID
Instagram.set 'client_secret', process.env.INSTAGRAMSECRET

app.get '/', (req, res) ->
    name = req.query.name

    if name
        Instagram.users.search {
            q: name,
            complete: (data, pagination) ->
                Instagram.users.recent {
                    user_id: data[0].id,
                    complete: (data, pagination) ->
                        res.send data
                }
        }
    else
        Instagram.media.popular {
            complete: (data, pagination) ->
                res.send data
        }

app.listen 3131
